resource "aws_security_group" "db_security_group" {
  name_prefix = "${var.environment_name}-rds-security-group-"

  vpc_id = var.vpc_id

  # allow this vpc and any peering vpc within a private network
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    Name           = "${var.environment_name} RDS security group"
    resource_group = var.environment_name
  }
}

