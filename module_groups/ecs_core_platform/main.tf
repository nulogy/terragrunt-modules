locals {
  desired_capacity = "${length(var.desired_capacity) > 0 ? var.desired_capacity : "2"}"
  max_size = "${length(var.max_size) > 0 ? var.max_size : "4"}"
  min_size = "${length(var.min_size) > 0 ? var.min_size : "2"}"
}

module "vpc" {
  source = "/deployer/modules/vpc"

  environment_name = "${var.environment_name}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "ecs_subnets" {
  source = "/deployer/modules/public_private_subnets"

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
  source = "/deployer/module_groups/ecs_cluster"

  desired_capacity = "${local.desired_capacity}"
  max_size = "${local.max_size}"
  min_size = "${local.min_size}"
  health_check_type = "${var.health_check_type}"

  cluster_name = "${var.environment_name}-cluster"
  ecs_ami = "${var.ecs_ami}"
  ecs_ami_owner = "${var.ecs_ami_owner}"
  ec2_public_key = "${var.ec2_public_key}"
  environment_name = "${var.environment_name}"
  lc_instance_type = "${var.lc_instance_type}"
  private_subnet_ids = "${module.ecs_subnets.private_subnet_ids}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "log_group" {
  source = "/deployer/modules/log_group"

  name = "${var.environment_name}-log"
}

module "vpc_peering_connection" {
  source = "/deployer/modules/vpc_peering_connection"
  skip = "${length(var.peer_account_id) == 0 ? "true" : ""}"

  environment_name = "${var.environment_name}"
  peer_account_id = "${var.peer_account_id}"
  peer_vpc_id = "${var.peer_vpc_id}"
  vpc_id = "${module.vpc.vpc_id}"
  auto_accept = "${var.peer_auto_accept}"
}

module "bastion_auto_scaling_group" {
  source = "/deployer/modules/bastion_auto_scaling_group"

  ec2_subnet_ids = "${module.ecs_subnets.public_subnet_ids}"
  ecs_ami = "${var.ecs_ami}"
  ecs_ami_owner = "${var.ecs_ami_owner}"
  environment_name = "${var.environment_name}"
  public_key = "${var.ec2_public_key}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${module.vpc.vpc_id}"
}
