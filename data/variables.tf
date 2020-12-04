variable "mainvpcname" {
  default = "ice-vmc-prod-vpc"
}

variable "transitvpcname" {
  default = "ice-transit-vmc-prod-vpc"
}

variable "publicdomain" {
  default = "vmcprod.ice.mod.gov.uk"
}

variable "publicsubnetnames" {
  type        = list(string)
  description = "A list of subnet names each public subnet"
  default     = ["ice-vmc-prod-puba", "ice-vmc-prod-pubb", "ice-vmc-prod-pubc"]
}

