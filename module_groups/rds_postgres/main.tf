module "rds_subnets" {
  source = "../../modules/private_subnets"

  environment_name = "${var.environment_name}"
  private_subnet_adjective = "RDS"
  private_subnets = "${var.private_rds_subnets}"
  skip = "${var.skip}"
  vpc_id = "${var.vpc_id}"
}

module "postgres_rds" {
  source = "../../modules/postgres_rds"

  allocated_storage = "${var.allocated_storage}"
  db_name = "${var.db_name}"
  db_password = "${var.db_password}"
  db_username = "${var.db_username}"
  engine_version = "${var.engine_version}"
  environment_name = "${var.environment_name}"
  instance_class = "${var.instance_class}"
  parameter_group_name = "${var.parameter_group_name}"
  production_mode = "${var.production_mode}"
  rds_subnet_ids = "${module.rds_subnets.private_subnet_ids}"
  skip = "${var.skip}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${var.vpc_id}"
}