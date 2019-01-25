resource "aws_security_group" "event_shovel" {
  name = "${var.environment_name} Event Shovel"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.environment_name} Event Shovel"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_security_group_rule" "event_shovel_allow_egress_to_everywhere" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  security_group_id = "${aws_security_group.event_shovel.id}"

  cidr_blocks = [ "0.0.0.0/0" ]
}
