variable "mainvpcname" {
  default = "ice-ad-modcloud-prod-vpc"
}

variable "custexample" {
}

variable "transitvpcname" {
  default = "ice-transit-ad-modcloud-prod-vpc"
}

variable "publicdomain" {
  default = "vmcprod.ice.mod.gov.uk"
}

variable "publicsubnetnames" {
  type        = list(string)
  description = "A list of subnet names each public subnet"
  default     = ["ice-ad-modcloud-prod-puba"]
}

