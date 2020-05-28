output "account_name" {
  value = data.aws_iam_account_alias.current.account_alias
}

output "account_dns_zone_id" {
  value = data.aws_route53_zone.account_zone.id
}

output "account_dns_zone_name" {
  value = data.aws_route53_zone.account_zone.name
}

output "shared_vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "shared_public_subnet_ids" {
  value = data.aws_subnet_ids.public_subnets.ids
}

output "shared_private_subnet_ids" {
  value = data.aws_subnet_ids.private_subnets.ids
}

output "shared_vpc_cidr" {
  value = data.aws_vpc.vpc.cidr_block
}

output "shared_vpc_cidr_ipv6" {
  value = data.aws_vpc.vpc.ipv6_cidr_block
}
