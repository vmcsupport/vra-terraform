terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
    }
  }
}

provider "random" {
  version = "3.0.0"
}
