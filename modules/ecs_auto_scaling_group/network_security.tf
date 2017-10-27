resource "aws_security_group" "ecs_ec2_security_group" {
  name_prefix = "${var.environment_name}-ecs-ec2-security-group-"

  vpc_id = "${var.vpc_id}"

  # Only allow connections from within the VPC
  ingress {
    cidr_blocks = ["${var.vpc_cidr}"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

  # Outbound connections need to be opened for third-party services (ie, New Relic)
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

  tags {
    Name = "${var.environment_name} ECS security group"
    resource_group = "${var.environment_name}"
  }
}
