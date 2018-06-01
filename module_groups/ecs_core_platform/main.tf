locals {
  desired_capacity = "${length(var.desired_capacity) > 0 ? var.desired_capacity : "2"}"
  ecs_ami_version = "${length(var.ecs_ami_version) > 0 ? var.ecs_ami_version : "2017.09.g"}"
  max_size = "${length(var.max_size) > 0 ? var.max_size : "4"}"
  min_size = "${length(var.min_size) > 0 ? var.min_size : "2"}"
}

module "vpc" {
  source = "/deployer/modules//vpc"
  skip = "${var.skip}"

  environment_name = "${var.environment_name}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "ecs_subnets" {
  source = "/deployer/modules//public_private_subnets"
  skip = "${var.skip}"

  environment_name = "${var.environment_name}"
  internet_gw_id = "${module.vpc.internet_gw_id}"
  private_subnets = "${var.private_ecs_subnets}"
  public_subnets = "${var.public_subnets}"
  subnet_adjective = "ECS"
  vpc_id = "${module.vpc.vpc_id}"
  peer_vpc_cidr = "${var.peer_vpc_cidr}"
  vpc_peering_connection_id = "${module.vpc_peering_connection.vpc_peering_connection_id}"
}

module "ecs_cluster" {
  source = "/deployer/modules//ecs_cluster"
  skip = "${var.skip}"

  name = "${var.environment_name}-cluster"
}

module "ecs_auto_scaling_group" {
  source = "/deployer/modules//ecs_auto_scaling_group"
  skip = "${var.skip}"

  desired_capacity = "${local.desired_capacity}"
  max_size = "${local.max_size}"
  min_size = "${local.min_size}"
  health_check_type = "${var.health_check_type}"

  ec2_subnet_ids = "${module.ecs_subnets.private_subnet_ids}"
  ecs_ami_version = "${local.ecs_ami_version}"
  ecs_cluster_name = "${module.ecs_cluster.ecs_cluster_name}"
  environment_name = "${var.environment_name}"
  lc_instance_type = "${var.lc_instance_type}"
  public_key = "${var.ec2_public_key}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "log_group" {
  source = "/deployer/modules//log_group"
  skip = "${var.skip}"

  name = "${var.environment_name}-log"
}

module "vpc_peering_connection" {
  source = "/deployer/modules//vpc_peering_connection"
  skip = "${length(var.peer_account_id) == 0 ? "true" : ""}"

  environment_name = "${var.environment_name}"
  peer_account_id = "${var.peer_account_id}"
  peer_vpc_id = "${var.peer_vpc_id}"
  vpc_id = "${module.vpc.vpc_id}"
  auto_accept = "${var.peer_auto_accept}"
}

module "bastion_auto_scaling_group" {
  source = "/deployer/modules//bastion_auto_scaling_group"

  ec2_subnet_ids = "${module.ecs_subnets.public_subnet_ids}"
  ecs_ami_version = "${local.ecs_ami_version}"
  environment_name = "${var.environment_name}"
  public_key = "${var.ec2_public_key}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${module.vpc.vpc_id}"
}
