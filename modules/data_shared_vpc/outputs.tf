output "cross_vpc_cidr" {
  value = local.cross_vpc_cidr
}

output "private_subnet_ids" {
  value = sort(data.aws_subnet_ids.private_subnets.ids)
}

output "public_subnet_ids" {
  value = sort(data.aws_subnet_ids.public_subnets.ids)
}

output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = data.aws_vpc.vpc.cidr_block
}

output "vpc_cidr_ipv6" {
  value = data.aws_vpc.vpc.ipv6_cidr_block
}
