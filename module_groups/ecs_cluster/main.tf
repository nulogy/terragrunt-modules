locals {
  desired_capacity = "${length(var.desired_capacity) > 0 ? var.desired_capacity : "2"}"
  max_size = "${length(var.max_size) > 0 ? var.max_size : "4"}"
  min_size = "${length(var.min_size) > 0 ? var.min_size : "2"}"
}

data "aws_region" "current" {}

module "ecs_auto_scaling_group" {
  source = "/deployer/modules/ecs_auto_scaling_group"

  desired_capacity = "${local.desired_capacity}"
  health_check_type = "${var.health_check_type}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"

  ec2_subnet_ids = "${var.private_subnet_ids}"
  ecs_ami = "${var.ecs_ami}"
  ecs_ami_owner = "${var.ecs_ami_owner}"
  ecs_cluster_name = "${module.ecs_cluster.ecs_cluster_name}"
  environment_name = "${var.environment_name}"
  lc_instance_type = "${var.lc_instance_type}"
  public_key = "${var.ec2_public_key}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${var.vpc_id}"
}

module "ecs_cluster" {
  source = "/deployer/modules/ecs_cluster"

  name = "${var.cluster_name}"
}
