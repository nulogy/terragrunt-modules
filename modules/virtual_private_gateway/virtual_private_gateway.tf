resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.environment_name} Virtual Private Gateway"
    resource_group = "${var.environment_name}"
  }
}