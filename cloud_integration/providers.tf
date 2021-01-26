provider "vra" {
  url           = var.vra_url
  refresh_token = var.refresh_token
}

provider "aws" {
  region = var.region
}
