module "datalookup" {
  source = "../data"
}

resource "aws_security_group" "ec2_security_groups" {
  name   = join("-", ["vmc", var.custproj, "sgalb", module.datalookup.random_value.hex])
  vpc_id = module.datalookup.mainvpc.id
}

resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules)
  type  = "ingress"
  from_port         = var.ingress_rules[count.index].port
  to_port           = var.ingress_rules[count.index].port
  protocol          = "TCP"
  cidr_blocks       = [var.ingress_rules[count.index].cidr_blocks]
  security_group_id = aws_security_group.ec2_security_groups.id
}

resource "aws_lb" "alb_public_to_vmc" {
  name               = join("-", ["vmc", var.custproj, "alb", module.datalookup.random_value.hex])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_security_groups.id]
  subnets            = module.datalookup.public_subnets.ids

  enable_deletion_protection = false

#    access_logs {
#      bucket  = aws_s3_bucket.lb_logs.bucket
#      prefix  = "test-lb"
#      enabled = true
#    }

  tags = merge(
    local.common_tags,
    {
      "Name" = join("-", ["vmc", var.custproj, "alb", module.datalookup.random_value.hex])
    }
  )
}

resource "aws_lb_listener" "alb_listen_rules" {
  count             = length(var.ingress_rules)
  load_balancer_arn = aws_lb.alb_public_to_vmc.arn
  port              = var.ingress_rules[count.index].port
  protocol          = "HTTPS"
  certificate_arn   = module.datalookup.acmpublicdomain.arn
  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group[count.index].arn
    type             = "forward"
  }
}

resource "aws_route53_record" "alb_public_record_to_vmc" {
  zone_id = module.datalookup.publicdomain.zone_id
  name    = var.publicfriendlyname
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.alb_public_to_vmc.dns_name]
}

resource "aws_lb_target_group" "alb_target_group" {
  count                = length(var.ingress_rules)
  name                 = join("-", ["vmc", var.custproj, count.index + 1, "alb", module.datalookup.random_value.hex])
  port                 = var.ingress_rules[count.index].port
  protocol             = var.ingress_rules[count.index].protocol
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
    port                = var.ingress_rules[count.index].port
    protocol            = var.ingress_rules[count.index].protocol
    interval            = 10
  }

  #  tags = {
  #    domain_zone = "${var.domain_zone}"
  #  }
}

# attaches instances into target group
#resource "aws_lb_target_group_attachment" "customer_to_public_tg_attachment" {
#  for_each = toset(var.customerip)
#  target_group_arn  = aws_lb_target_group.alb_target_group.arn
#  target_id         = each.value
#  availability_zone = "all"
#  #  lifecycle {
#  #    ignore_changes = true
#  #
#  #    # This is a requirement however it means you need to apply twice if adding a new instance
#  #    # without this it will try to remove ALL instances if making any additions
#  #  }
#
#  depends_on = [aws_lb_target_group.alb_target_group]
#}

resource "aws_lb_target_group_attachment" "customer_to_public_tg_attachment" {
  count             = length(var.ingress_rules) * length(var.computerip)
  target_group_arn  = aws_lb_target_group.alb_target_group[floor(count.index / length(var.computerip))].arn
  target_id         = var.computerip[count.index % length(var.computerip)]
  availability_zone = "all"
  depends_on        = [aws_lb_target_group.alb_target_group]

  lifecycle {
    create_before_destroy = true
  }

}
