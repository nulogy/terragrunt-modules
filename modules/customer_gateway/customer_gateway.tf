locals {
  desired_capacity = length(var.bgp_asn) > 0 ? var.bgp_asn : "65000"
}

resource "aws_customer_gateway" "customer_gateway" {
  count = length(var.skip) > 0 ? 0 : 1

  bgp_asn    = var.bgp_asn
  ip_address = var.remote_ip
  type       = "ipsec.1"

  tags = {
    Name           = "${var.environment_name} Customer Gateway"
    resource_group = var.environment_name
  }
}

