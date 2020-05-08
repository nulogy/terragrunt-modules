resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = "${var.environment_name}-rds-subnet-group-"
  subnet_ids  = var.subnet_ids

  tags = {
    Name           = "${var.environment_name} RDS subnet group"
    resource_group = var.environment_name
  }
}

