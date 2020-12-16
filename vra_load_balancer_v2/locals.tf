locals {
  common_tags = {
    owner       = var.custowner
    custproject = var.custproj
    customer    = substr(var.custproj, 0, 3)
    project     = substr(var.custproj, 3, 3)
    uin         = var.custuin
  }
}
############### end of template ###############

locals {
  publicfriendlyname = var.publicfriendlyname != "" ? var.publicfriendlyname : join("-", ["vmc", var.custproj, "alb", module.datalookup.random_value.hex])
}
