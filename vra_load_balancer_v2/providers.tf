#terraform {
#  required_providers {
#    aws = {
#      source = "hashicorp/aws"
#    }
#  }
#  required_version = ">= 0.13"
#}

#provider = "registry.terraform.io/-/aws"

provider "aws" {
  region = "eu-west-2"
}
