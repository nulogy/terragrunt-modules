data "aws_subnet_ids" "subnet_ids" {
  vpc_id = var.vpc_id
}

data "aws_route_table" "route_tables" {
  count     = length(data.aws_subnet_ids.subnet_ids.ids)
  subnet_id = sort(data.aws_subnet_ids.subnet_ids.ids)[count.index]
}

resource "aws_route" "routes" {
  count = length(var.skip) > 0 ? 0 : length(data.aws_route_table.route_tables.*.id)

  route_table_id            = element(data.aws_route_table.route_tables.*.id, count.index)
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_connection[0].id
}

