data "aws_caller_identity" "peer" {}

resource "aws_vpc_peering_connection" "vpc_peering_connection" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  peer_owner_id = "${data.aws_caller_identity.peer.account_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.vpc_id}"
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags {
    Name = "VPC Peering Connection ${var.environment_name}"
    resource_group = "${var.environment_name}"
  }
}
