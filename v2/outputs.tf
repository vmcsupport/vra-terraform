output "tag_owner" {
  description = "owner tag value"
  value       = local.common_tags.owner
}

output "tag_custproject" {
  description = "custproject tag value"
  value       = local.common_tags.custproject
}

output "tag_customer" {
  description = "customer tag value"
  value       = local.common_tags.customer
}

output "tag_project" {
  description = "project tag value"
  value       = local.common_tags.project
}

output "tag_uin" {
  description = "uin tag value"
  value       = local.common_tags.uin
}

output "random_value" {
  description = "random"
  value       = module.datalookup.random_value.*
}

############### end of template ###############

output "loadbalancer_address" {
  description = "load balancer Amazon dns_name"
  value       = aws_lb.alb_public_to_vmc.dns_name
}

output "public_dns_name2" {
  value = "${local.publicfriendlyname}.${module.datalookup.acmpublicdomain.domain}"
}

output "public_dns_name" {
  value = "${local.publicfriendlyname}.${module.datalookup.acmpublicdomain.domain}"
}
