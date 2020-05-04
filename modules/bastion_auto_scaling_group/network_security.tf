resource "aws_security_group" "ecs_ec2_security_group" {
  count = length(var.skip) > 0 ? 0 : 1

  name_prefix = "${var.environment_name}-bastion-security-group-"

  vpc_id = var.vpc_id

  # Allow connections from within the VPC
  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  # Allow SSH connections from the office
  ingress {
    cidr_blocks = ["${var.office_ip}/32"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # Outbound connections are open
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name           = "${var.environment_name} Bastion security group"
    resource_group = var.environment_name
  }
}

