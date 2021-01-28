variable "cloudzone" {
  type        = string
  description = "VRA Cloud Zone"
}

variable "image" {
  type        = string
  description = "OS version"
}

variable "instance_type" {
  type        = string
  description = "instance type"
}

variable "custexample" {
  type        = string
  default     = "modcloud"
}

variable "instance_name" {
  type        = string
  description = "instance name"
}

