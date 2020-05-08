locals {
  skip_final_snapshot = false == var.production_mode
  encrypted_storage   = var.production_mode
  multi_az            = var.production_mode
}

resource "aws_db_instance" "db" {
  count = length(var.skip) > 0 ? 0 : 1

  allocated_storage          = var.db_allocated_storage
  auto_minor_version_upgrade = true
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group[0].name
  engine                     = "postgres"
  engine_version             = var.engine_version
  final_snapshot_identifier  = "${var.environment_name}-db"
  identifier_prefix          = "${var.environment_name}-db-"
  instance_class             = var.instance_class
  multi_az                   = local.multi_az
  name                       = var.db_name
  parameter_group_name       = var.parameter_group_name
  password                   = var.db_password
  skip_final_snapshot        = local.skip_final_snapshot
  storage_encrypted          = local.encrypted_storage
  storage_type               = "gp2"
  username                   = var.db_username
  vpc_security_group_ids     = [aws_security_group.db_security_group[0].id]
  snapshot_identifier        = var.db_snapshot_identifier

  tags = {
    resource_group = var.environment_name
  }
}

