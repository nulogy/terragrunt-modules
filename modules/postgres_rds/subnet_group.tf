resource "aws_db_subnet_group" "rds_subnet_group" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "${var.environment_name}-rds-subnet-group-"
  subnet_ids = ["${var.rds_subnet_ids}"]

  tags {
    Name = "${var.environment_name} RDS subnet group"
    resource_group = "${var.environment_name}"
  }
}