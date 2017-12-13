locals {
  subdomain = "${length(var.route53_subdomain) > 0 ? "plb-${var.route53_subdomain}" : "plb"}"
}

module "ecs_core_platform" {
  source = "../ecs_core_platform"
  skip = "${var.skip}"

  desired_capacity = "${var.desired_capacity}"
  ec2_public_key = "${var.ec2_public_key}"
  ecs_ami_version = "${var.ecs_ami_version}"
  environment_name = "${var.environment_name}"
  lc_instance_type = "${var.lc_instance_type}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  peer_account_id = "${var.peer_account_id}"
  peer_vpc_cidr = "${var.peer_vpc_cidr}"
  peer_vpc_id = "${var.peer_vpc_id}"
  private_ecs_subnets = "${var.private_ecs_subnets}"
  public_subnets = "${var.public_subnets}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "public_load_balancer" {
  source = "../../modules/public_load_balancer"
  skip = "${var.skip}"

  alb_subnets = "${module.ecs_core_platform.public_subnet_ids}"
  cert_domain = "${var.cert_domain}"
  environment_name = "${var.environment_name}"
  vpc_id = "${module.ecs_core_platform.vpc_id}"
}

module "route53_for_load_balancer" {
  source = "../../modules/route53_alias_record"
  skip = "${var.skip}"

  domain = "${var.route53_domain}"
  subdomain = "${local.subdomain}"
  target_domain = "${module.public_load_balancer.dns_name}"
  target_zone_id = "${module.public_load_balancer.zone_id}"
}
