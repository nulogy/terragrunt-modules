resource "aws_subnet" "public_subnets" {
  count = "${length(var.skip) > 0 ? 0 : length(var.public_subnets)}"

  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[count.index]}"
  cidr_block = "${var.public_subnets[count.index]}"

  tags {
    Name = "${var.environment_name} public ${var.subnet_adjective} subnet ${count.index + 1}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table" "public_routing_tables" {
  count = "${length(var.skip) > 0 ? 0 : length(var.public_subnets)}"
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gw_id}"
  }

  tags {
    Name = "${var.environment_name} public ${var.subnet_adjective} subnets routing table ${count.index + 1}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "public_associations" {
  count = "${length(var.skip) > 0 ? 0 : length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public_routing_tables.*.id, count.index)}"
}