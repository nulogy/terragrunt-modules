resource "aws_db_instance" "db" {
  allocated_storage = 8
  auto_minor_version_upgrade = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.name}"
  engine = "postgres"
  engine_version = "9.4"
  final_snapshot_identifier = "${var.environment_name}-db"
  identifier_prefix = "${var.environment_name}-db-"
  instance_class = "db.t2.micro"
  multi_az = false
  name = "${var.db_name}"
  parameter_group_name = "default.postgres9.4"
  password = "${data.aws_ssm_parameter.db_password.value}"
  skip_final_snapshot = true
  storage_encrypted = false
  storage_type = "gp2"
  username = "${var.rds_db_username}"
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]

  lifecycle {
    prevent_destroy = false #Should be `true` in production
  }

  tags {
    resource_group = "${var.environment_name}"
  }
}
