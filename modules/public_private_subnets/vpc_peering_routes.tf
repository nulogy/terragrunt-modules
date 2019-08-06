locals {
  vpc_peering_route_count = length(var.peer_vpc_cidr) == 0 ? 0 : length(var.private_subnets)
}

resource "aws_route" "private_vpc_peering_connection_route" {
  count = length(var.skip) > 0 ? 0 : local.vpc_peering_route_count

  route_table_id            = element(aws_route_table.private_routing_tables.*.id, count.index)
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

