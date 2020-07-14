data "aws_route_tables" "acceptor_routing_tables" {
  provider = aws.acceptor
  vpc_id = var.acceptor_vpc_id
}

resource "aws_route" "routes_for_acceptor_vpc" {
  provider = aws.acceptor

  for_each = data.aws_route_tables.acceptor_routing_tables.ids

  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.requester_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acceptor.vpc_peering_connection_id
}

data "aws_route_tables" "requester_routing_tables" {
  provider = aws.requester
  vpc_id = var.requester_vpc_id
}

resource "aws_route" "routes_for_requester_vpc" {
  provider = aws.requester

  for_each = data.aws_route_tables.requester_routing_tables.ids

  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.acceptor_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
}