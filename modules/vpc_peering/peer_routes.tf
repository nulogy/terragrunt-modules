data "aws_vpc" "requester_vpc" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "peer_subnet_ids" {
  vpc_id = "${var.peer_vpc_id}"
}

data "aws_subnet" "peer_subnets" {
  count = "${length(data.aws_subnet_ids.peer_subnet_ids.ids)}"
  id = "${data.aws_subnet_ids.peer_subnet_ids.ids[count.index]}"
}

data "aws_route_table" "peer_route_tables" {
  count = "${length(data.aws_subnet.peer_subnets.*.id)}"
  subnet_id = "${element(data.aws_subnet.peer_subnets.*.id, count.index)}"
}

resource "aws_route" "peer_routes" {
  count = "${length(data.aws_route_table.peer_route_tables.*.id)}"

  route_table_id = "${element(data.aws_route_table.peer_route_tables.*.id, count.index)}"
  destination_cidr_block = "${data.aws_vpc.requester_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_peering_connection.id}"
}
