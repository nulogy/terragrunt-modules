data "aws_subnet_ids" "subnet_ids" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "subnets" {
  count = length(data.aws_subnet_ids.subnet_ids.ids)
  id    = data.aws_subnet_ids.subnet_ids.ids[count.index]
}

data "aws_route_table" "route_tables" {
  count     = length(data.aws_subnet.subnets.*.id)
  subnet_id = element(data.aws_subnet.subnets.*.id, count.index)
}

resource "aws_route" "routes" {
  count = length(var.skip) > 0 ? 0 : length(data.aws_route_table.route_tables.*.id)

  route_table_id            = element(data.aws_route_table.route_tables.*.id, count.index)
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_connection[0].id
}

