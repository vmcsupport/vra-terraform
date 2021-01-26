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

resource "aws_security_group_rule" "ingress_rules_good" {
  for_each          = var.ingress_rules
  type              = "ingress"
  from_port         = each.value["port"]
  to_port           = each.value["port"]
  protocol          = "TCP"
  cidr_blocks       = each.value["cidr_blocks"]
  security_group_id = aws_security_group.ec2_security_groups.id
}

resource "aws_security_group_rule" "ingress_rules_bad" {
  for_each          = { for x in var.ingress_rules_bad : x.port => x }
  type              = "ingress"
  from_port         = each.value["port"]
  to_port           = each.value["port"]
  protocol          = "TCP"
  cidr_blocks       = [each.value["cidr_blocks"]]
  security_group_id = aws_security_group.ec2_security_groups.id
}
