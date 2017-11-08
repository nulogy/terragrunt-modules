locals {
  subdomain = "plb-${var.route53_subdomain}"
}

module "vpc" {
  source = "../../modules/vpc"

  environment_name = "${var.environment_name}"
  skip = "${var.skip}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "ecs_subnets" {
  source = "../../modules/public_private_subnets"

  environment_name = "${var.environment_name}"
  internet_gw_id = "${module.vpc.internet_gw_id}"
  private_subnets = "${var.private_ecs_subnets}"
  public_subnets = "${var.public_subnets}"
  skip = "${var.skip}"
  subnet_adjective = "ECS"
  vpc_id = "${module.vpc.vpc_id}"
}

module "ecs_cluster" {
  source = "../../modules/ecs_cluster"

  name = "${var.environment_name}-cluster"
  skip = "${var.skip}"
}

module "ecr" {
  source = "../../modules/ecr"

  name = "${var.environment_name}"
  skip = "${var.skip}"
}

module "ecs_auto_scaling_group" {
  source = "../../modules/ecs_auto_scaling_group"

  desired_capacity = "2"
  max_size = "4"
  min_size = "2"

  ec2_subnet_ids = "${module.ecs_subnets.private_subnet_ids}"
  ecs_ami_version = "${var.ecs_ami_version}"
  ecs_cluster_name = "${module.ecs_cluster.ecs_cluster_name}"
  environment_name = "${var.environment_name}"
  lc_instance_type = "${var.lc_instance_type}"
  public_key = "${var.ec2_public_key}"
  skip = "${var.skip}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "public_load_balancer" {
  source = "../../modules/public_load_balancer"

  alb_subnets = "${module.ecs_subnets.public_subnet_ids}"
  cert_domain = "${var.cert_domain}"
  environment_name = "${var.environment_name}"
  skip = "${var.skip}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "route53_for_load_balancer" {
  source = "../../modules/route53_alias_record"

  domain = "${var.route53_domain}"
  skip = "${(length(var.skip_route53) == 0 && length(var.skip) == 0) ? 1 : 0}"
  subdomain = "${local.subdomain}"
  target_domain = "${module.public_load_balancer.dns_name}"
  target_zone_id = "${module.public_load_balancer.zone_id}"
}

module "log_group" {
  source = "../../modules/log_group"

  name = "${var.environment_name}-log"
  skip = "${var.skip}"
}