resource "aws_vpc" "vpc" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "VPC ${var.environment_name}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  count = "${(length(var.skip) > 0 || length(var.skip_gw) > 0) ? 0 : 1}"

  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "IGW ${var.environment_name}"
    resource_group = "${var.environment_name}"
  }
}