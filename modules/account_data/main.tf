data "aws_iam_account_alias" "current" {}

data "aws_vpc" "vpc" {
  filter {
    name   = "owner-id"
    values = ["033823102342", "278378425242"]
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

data "aws_route53_zone" "account_zone" {
  name = coalesce(var.account_zone_name, "${replace(data.aws_iam_account_alias.current.account_alias, "nulogy-", "")}.${var.root_dns}")
}
