############### end of template ###############
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
}
