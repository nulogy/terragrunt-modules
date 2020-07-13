data "aws_vpc" "requester_vpc" {
  provider = aws.requester
  id       = var.requester_vpc_id
}

data "aws_vpc" "acceptor_vpc" {
  provider = aws.acceptor
  id       = var.acceptor_vpc_id
}

resource "aws_vpc_peering_connection" "requester" {
  provider = aws.requester

  peer_owner_id = var.acceptor_account_id
  peer_vpc_id   = var.acceptor_vpc_id
  vpc_id        = var.requester_vpc_id
  auto_accept   = false

  tags = {
    Name = "Peer to ${data.aws_vpc.acceptor_vpc.tags["Name"]}"
  }
}

resource "aws_vpc_peering_connection_accepter" "acceptor" {
  provider = aws.acceptor

  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
  auto_accept               = true

  tags = {
    Name = "Peer to ${data.aws_vpc.requester_vpc.tags["Name"]}"
  }
}


resource "aws_vpc_peering_connection_options" "requester" {
  provider = aws.requester

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acceptor.id

  requester {
    allow_classic_link_to_remote_vpc = false
    allow_remote_vpc_dns_resolution  = true
    allow_vpc_to_remote_classic_link = false
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.acceptor

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acceptor.id

  accepter {
    allow_classic_link_to_remote_vpc = false
    allow_remote_vpc_dns_resolution  = true
    allow_vpc_to_remote_classic_link = false
  }
}