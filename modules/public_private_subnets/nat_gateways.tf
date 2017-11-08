resource "aws_eip" "nat" {
  count = "${length(var.skip) > 0 ? 0 : length(var.private_subnets)}"

  vpc = true
}

resource "aws_nat_gateway" "nat_gateways" {
  count = "${length(var.skip) > 0 ? 0 : length(var.private_subnets)}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnets.*.id, count.index)}"

  tags {
    Name = "${var.environment_name} nat gateway ${count.index + 1}"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route" "private_nat_gateway_route" {
  count = "${length(var.skip) > 0 ? 0 : length(var.private_subnets)}"

  route_table_id         = "${element(aws_route_table.private_routing_tables.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gateways.*.id, count.index)}"
}