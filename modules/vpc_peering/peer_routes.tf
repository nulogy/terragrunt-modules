data "aws_vpc" "requester_vpc" {
  id = "${var.vpc_id}"
}

data "aws_route_table" "peer_route_tables" {
  count = "${length(var.peer_vpc_subnets)}"
  subnet_id = "${element(var.peer_vpc_subnets, count.index)}"
}

resource "aws_route" "peer_routes" {
  count = "${length(var.skip) > 0 ? 0 : length(data.aws_route_table.peer_route_tables.*.id)}"

  route_table_id = "${element(data.aws_route_table.peer_route_tables.*.id, count.index)}"
  destination_cidr_block = "${data.aws_vpc.requester_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}
