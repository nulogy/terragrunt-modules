locals {
  account_ids    = {
    internal = "033823102342"
    external = "278378425242"
  }
  vpc_account_id = lookup(local.account_ids, var.type)

  cross_vpc_cidrs = {
    internal = "10.64.0.0/11"
    external = "10.96.0.0/11"
  }
  cross_vpc_cidr = lookup(local.cross_vpc_cidrs, var.type)
}

data "aws_vpc" "vpc" {
  filter {
    name   = "owner-id"
    values = [local.vpc_account_id]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Scope"
    values = ["public"]
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Scope"
    values = ["private"]
  }
}
