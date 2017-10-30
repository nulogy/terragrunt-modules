resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = "${var.environment_name}-rds-subnet-group-"
  subnet_ids = ["${var.rds_subnets}"]

  tags {
    Name = "${var.environment_name} RDS subnet group"
    resource_group = "${var.environment_name}"
  }
}