terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    vra = {
      source = "vmware/vra"
    }
  }
  required_version = ">= 0.13"
}
