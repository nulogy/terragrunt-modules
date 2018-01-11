resource "aws_route" "vpc_routes" {
  count = "${length(var.skip) > 0 ? 0 : length(var.routing_tables)}"

  route_table_id = "${element(var.routing_tables, count.index)}"
  destination_cidr_block = "${var.peer_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}