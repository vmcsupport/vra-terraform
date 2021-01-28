output "ami_id" {
  description = "owner tag value"
  value       = data.aws_ami.latest.id
}

#output "public_subnets" {
#  description = "List of public subnets"
#  value       = data.aws_subnet_ids.public_subnets
#}

output "public_subnets_ids" {
  description = "List of public subnet ids"
  value       = module.datalookup.public_subnets_ids
}


