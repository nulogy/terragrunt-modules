module "public_load_balancer" {
  source = "/deployer/modules/public_load_balancer"

  alb_subnets = "${module.ecs_core_platform.public_subnet_ids}"
  cert_domain = "${var.cert_domain}"
  environment_name = "${var.environment_name}"
  health_check_path = "${var.health_check_path}"
  vpc_id = "${module.ecs_core_platform.vpc_id}"
}

module "ecs_service_fargate_elb" {
  source = "/deployer/modules/ecs_service_fargate_elb"

  container_port = "${var.app_server__container_port}"
  desired_capacity = "${var.app_server__desired_capacity}"
  environment_name = "${var.environment_name}"
  max_size = "${var.app_server__max_size}"
  min_size = "${var.app_server__min_size}"
  private_ecs_subnets = "${}"
  vpc_cidr = "${var.vpc_cidr}"
}
