resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "VPC ${var.environment_name}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "IGW ${var.environment_name}"
    resource_group = "${var.environment_name}"
  }
}