resource "aws_security_group" "db_security_group" {
  count = length(var.skip) > 0 ? 0 : 1

  name_prefix = "${var.environment_name}-rds-security-group-"

  vpc_id = var.vpc_id

  # psql connections from within the VPC
  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  # Replies back to within the VPC
  egress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name           = "${var.environment_name} RDS security group"
    resource_group = var.environment_name
  }
}

