module "rds_subnets" {
  source = "/deployer/modules//private_subnets"
  skip = "${var.skip}"

  environment_name = "${var.environment_name}"
  private_subnet_adjective = "RDS"
  private_subnets = "${var.private_rds_subnets}"
  vpc_id = "${var.vpc_id}"
}

module "postgres_rds" {
  source = "/deployer/modules//postgres_rds"
  skip = "${var.skip}"

  db_allocated_storage = "${var.db_allocated_storage}"
  db_name = "${var.db_name}"
  db_password = "${var.db_password}"
  db_snapshot_identifier = "${var.db_snapshot_identifier}"
  db_username = "${var.db_username}"
  engine_version = "${var.engine_version}"
  environment_name = "${var.environment_name}"
  instance_class = "${var.instance_class}"
  parameter_group_name = "${var.parameter_group_name}"
  production_mode = "${var.production_mode}"
  rds_subnet_ids = "${module.rds_subnets.private_subnet_ids}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${var.vpc_id}"
}
