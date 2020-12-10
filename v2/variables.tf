variable "custproj" {
  type        = string
  description = "Customer and Project - passed via vRA"
  ##  default     = "custprojnotset"
}

variable "custowner" {
  type        = string
  description = "Owner - passed via vRA"
  ##  default     = "custowner"
}

variable "custuin" {
  type        = string
  description = "Customer UIN - passed via vRA"
  ##  default     = "custuin"
}

############### end of template ###############
variable "computerip" {
  type        = list
  description = "ip to attach to the target group"
  #  default     = ["192.168.56.131"]
}

variable "publicfriendlyname" {
  type        = string
  description = "Friendly dns name to attach to ALB instances"
  default     = ""
}

variable "ingress_rules" {
  type = list(object({
    port        = number
    cidr_blocks = any
    protocol    = string
  }))
#  default = [
#    {
#      port = 443
#      cidr_blocks = ["notset"]
#      protocol    = HTTPS
#    }
#  ]
}

