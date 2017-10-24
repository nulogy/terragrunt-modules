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

resource "aws_security_group" "ecs_lb_security_group" {
  name_prefix = "go-ecs-lb-security-group-"

  vpc_id = "${var.vpc_id}"

  # Accept all public HTTP traffic
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  # Accept all public HTTPS traffic
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  # Allows all outbound traffic
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

  tags {
    Name = "${var.environment_name} load balancer security group"
    resource_group = "${var.environment_name}"
  }
}
