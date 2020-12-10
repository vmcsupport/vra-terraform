##########################################################
#Notes:
#
#If the output is set to an explicit wildcard
#data.<type>.<name>.id*
#Then it will wrap the output in [ ]. This will then
#need to be referenced as
#module.mymodule.<name>.<property>
#
#For this reason do not use wildcards to keep the code clean
#
#If you require friendler reference to a specific
#attribute then name the value <name>_<property> should be used
#but is to be avoided unless absolutely required
#
#
#output "public_subnets_ids" {
#  description = "List of public subnet ids"
#  value       = data.aws_subnet_ids.public_subnets.ids
#}
#
##########################################################

output "acmpublicdomain" {
  description = "Public DNS details"
  value       = data.aws_acm_certificate.acmpublicdomain
}

output "mainvpc" {
  description = "Main VPC id <see also transitvpc>"
  value       = data.aws_vpc.mainvpc
}

output "public_subnets" {
  description = "List of public subnets"
  value       = data.aws_subnet_ids.public_subnets
}

output "public_subnets_ids" {
  description = "List of public subnet ids"
  value       = data.aws_subnet_ids.public_subnets.ids
}

output "publicdomain" {
  description = "Public DNS details"
  value       = data.aws_route53_zone.publicdomain
}

output "random_value" {
  description = "randomly generated values"
  value       = random_id.random_value
}

output "transitvpc" {
  description = "Transit VPC id <see also vpcid>"
  value       = data.aws_vpc.transitvpc
}

output "s3_alb_logs" { 
  description = "S3 bucket for alb logs"
  value       = data.aws_s3_bucket.vra-alb-logs
}
