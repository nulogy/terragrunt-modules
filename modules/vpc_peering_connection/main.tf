resource "aws_vpc_peering_connection" "vpc_peering_connection" {
  count = length(var.skip) > 0 ? 0 : 1

  peer_owner_id = var.peer_account_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.vpc_id
  auto_accept   = var.auto_accept

  //  TODO: uncomment this once we don't need cross-account peering
  //  accepter {
  //    allow_remote_vpc_dns_resolution = true
  //  }

  //  requester {
  //    allow_remote_vpc_dns_resolution = true
  //  }

  tags = {
    Name           = "VPC Peering Connection ${var.environment_name}"
    resource_group = var.environment_name
  }
}

