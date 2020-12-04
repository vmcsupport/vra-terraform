data "aws_vpc" "mainvpc" {
  filter {
    name   = "tag:Name"
    values = [var.mainvpcname]
  }
}

data "aws_vpc" "transitvpc" {
  filter {
    name   = "tag:Name"
    values = [var.transitvpcname]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.mainvpc.id
  filter {
    name   = "tag:Name"
    values = var.publicsubnetnames
  }
}

data "aws_route53_zone" "publicdomain" {
  name         = var.publicdomain
  private_zone = false
}

data "aws_acm_certificate" "acmpublicdomain" {
  domain      = var.publicdomain
  statuses    = ["ISSUED"]
  most_recent = true
}
