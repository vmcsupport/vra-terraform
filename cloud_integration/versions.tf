terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    vra = {
      source = "vmware/vra"
      version = "0.3.3"
    }
  }
  required_version = ">= 0.13"
}
