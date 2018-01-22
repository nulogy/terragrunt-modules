locals {
  engine_version = "${length(var.db_snapshot_identifier) > 0 ? "${var.db_engine_version}" : ""}"
  # iops = "${var.db_storage_type == "io1" ? var.db_iops : 0}"
  name = "${length(var.db_snapshot_identifier) > 0 ? "${var.db_name}" : ""}"
  password = "${length(var.db_snapshot_identifier) > 0 ? "${var.db_password}" : ""}"
  username = "${length(var.db_snapshot_identifier) > 0 ? "${var.db_username}" : ""}"
}

resource "aws_db_instance" "db" {
  allocated_storage = "${var.db_allocated_storage}"
  apply_immediately = "${var.db_apply_immediatelly}"
  auto_minor_version_upgrade = "${var.db_auto_minor_version_upgrade}"
  backup_retention_period = "${var.db_backup_retention_period}"
  backup_window = "${var.db_backup_window}"
  copy_tags_to_snapshot = true
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.name}"
  engine = "postgres"
  engine_version = "${local.engine_version}"
  final_snapshot_identifier = "${var.environment_name}-db"
  iam_database_authentication_enabled = "${var.db_iam_database_authentication_enabled}"
  identifier_prefix = "${var.environment_name}-db-"
  instance_class = "${var.db_instance_class}"
  # iops = "${local.iops}"
  kms_key_id = "${var.db_kms_key_id}"
  license_model = ""
  maintenance_window = "${var.db_maintenance_window}"
  monitoring_interval = "${var.db_monitoring_interval}"
  monitoring_role_arn = "${aws_iam_role.monitoring.arn}"
  multi_az = true
  name = "${local.name}"
  option_group_name = ""
  parameter_group_name = "${var.db_parameter_group_name}"
  password = "${local.password}"
  port = "${var.db_port}"
  publicly_accessible = false
  replicate_source_db = "${var.db_replicate_source_db}"
  skip_final_snapshot = false
  snapshot_identifier = "${var.db_snapshot_identifier}"
  storage_encrypted = true
  storage_type = "${var.db_storage_type}"
  timezone = ""
  username = "${local.username}"
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]

  lifecycle {
    prevent_destroy = true
  }

  tags {
    resource_group = "${var.environment_name}"
  }
}
