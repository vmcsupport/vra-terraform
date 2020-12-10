module "datalookup" {
  source = "../data"
}

resource "aws_security_group" "ec2_security_groups" {
  name   = join("-", ["vmc", var.custproj, "sgalb", module.datalookup.random_value.hex])
  vpc_id = module.datalookup.mainvpc.id
  tags = merge(
    local.common_tags,
    {
      "Name" = join("-", ["vmc", var.custproj, "sgalb", module.datalookup.random_value.hex])
    }
  )
}

#resource "aws_security_group_rule" "ingress_rule" {
#  for_each = {
#    for pair in setproduct(var.ingress_rules, var.computerip) :
#    "${pair[0].port}:${pair[1]}" => {
#    port = pair[0].port
#    ip   = pair[1]
#    }
#  }
#  type              = "egress"
#  from_port         = each.value.port
#  to_port           = each.value.port
#  protocol          = "TCP"
#  cidr_blocks       = formatlist("%s/32", each.value.ip)
#  security_group_id = aws_security_group.ec2_security_groups.id
#}


resource "aws_security_group_rule" "ingress_rules" {
##  for_each = { for x in var.ingress_rules: x.cidr_blocks => x }
  for_each = { for x in var.ingress_rules: x.port => x }
  type              = "ingress"
  from_port         = each.value["port"]
  to_port           = each.value["port"]
  protocol          = "TCP"
  cidr_blocks       = [each.value["cidr_blocks"]]
  security_group_id = aws_security_group.ec2_security_groups.id
}

resource "aws_security_group_rule" "egress_rules" {
  for_each = { for x in var.ingress_rules: x.port => x }
  type              = "egress"
  from_port         = each.value["port"]
  to_port           = each.value["port"]
  protocol          = "TCP"
  cidr_blocks       = formatlist("%s/32", var.computerip)
  security_group_id = aws_security_group.ec2_security_groups.id
}

resource "aws_lb" "alb_public_to_vmc" {
  name               = join("-", ["vmc", var.custproj, "alb", module.datalookup.random_value.hex])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_security_groups.id]
  subnets            = module.datalookup.public_subnets.ids

  enable_deletion_protection = false

#      access_logs {
#        bucket  = module.datalookup.s3_alb_logs.bucket
#        prefix  = join("-", ["vmc", var.custproj, "alb", module.datalookup.random_value.hex])
#        enabled = true
#      }

  tags = merge(
    local.common_tags,
    {
      "Name" = join("-", ["vmc", var.custproj, "alb", module.datalookup.random_value.hex])
    }
  )
}

resource "aws_route53_record" "api_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value]
  ttl             = 60
  type            = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
  zone_id         = module.datalookup.publicdomain.zone_id
}

resource "aws_acm_certificate" "main" {
  domain_name       = "${local.publicfriendlyname}.${module.datalookup.acmpublicdomain.domain}"
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    {
      "Name" = join("-", ["vmc", var.custproj, "pub_acm_cert", module.datalookup.random_value.hex])
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_listen_rules" {
  for_each = { for x in var.ingress_rules: x.port => x }
  load_balancer_arn = aws_lb.alb_public_to_vmc.arn
  port              = each.value["port"]
  protocol          = each.value["protocol"]
  certificate_arn   = each.value["protocol"] == "HTTPS" ? (var.publicfriendlyname != "" ? aws_acm_certificate.main.arn : module.datalookup.acmpublicdomain.arn) : ""
  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group[each.key].arn
    type             = "forward"
  }
}

resource "aws_route53_record" "alb_public_record_to_vmc" {
  zone_id = module.datalookup.publicdomain.zone_id
  name    = local.publicfriendlyname
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.alb_public_to_vmc.dns_name]
}

resource "aws_lb_target_group" "alb_target_group" {
  for_each = { for x in var.ingress_rules: x.port => x }
  name                 = join("-", ["vmc", var.custproj, each.key, "alb", module.datalookup.random_value.hex])
  port                 = each.value["port"]
  protocol             = each.value["protocol"]
  vpc_id               = module.datalookup.mainvpc.id
  target_type          = "ip"
  deregistration_delay = 15

  lifecycle {
    create_before_destroy = true
  }

  # bring instances into service quicker
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = each.value["port"]
    protocol            = each.value["protocol"]
    interval            = 10
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = join("-", ["vmc", var.custproj, each.key, "alb", module.datalookup.random_value.hex])
    }
  )
}

resource "aws_lb_target_group_attachment" "customer_to_public_tg_attachment" { 
  for_each = {
    for pair in setproduct(keys(aws_lb_target_group.alb_target_group), var.computerip) :
    floor("${pair[0]}${replace(pair[1],".", "")}" / 10000000) => {
      target_group = aws_lb_target_group.alb_target_group[pair[0]]
      target_id  = pair[1]
    }
  }
  target_group_arn = each.value.target_group.arn
  target_id        = each.value.target_id
  availability_zone = "all"
}
