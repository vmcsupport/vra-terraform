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

data "aws_s3_bucket" "vra-alb-logs" {
  bucket      = "vmc-sddc-vra-customer-alb-logs"
}


data "aws_ami" "example" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["win2016-goldenimage*"]
  }
}
