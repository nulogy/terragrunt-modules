resource "aws_subnet" "private_subnets" {
  count = "${length(var.private_subnets)}"

  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[count.index]}"
  cidr_block = "${var.private_subnets[count.index]}"

  tags {
    Name = "${var.environment_name} private ${var.subnet_adjective} subnet ${count.index + 1}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table" "private_routing_tables" {
  count = "${length(var.private_subnets)}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.environment_name} private ${var.subnet_adjective} subnets routing table ${count.index + 1}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "private_associations" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_routing_tables.*.id, count.index)}"
}