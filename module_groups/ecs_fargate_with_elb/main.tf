module "log_group" {
  source = "/deployer/modules/log_group"

  name = "${var.environment_name}-${var.service_name}"
}

module "public_load_balancer" {
  source = "/deployer/modules/public_load_balancer"

  alb_subnets                      = var.public_subnets
  cert_domain                      = var.cert_domain
  environment_name                 = var.environment_name
  health_check_path                = var.health_check_path
  health_check_timeout             = var.health_check_timeout
  deregistration_delay             = var.deregistration_delay
  slow_start                       = var.slow_start
  stickiness_enabled               = var.stickiness_enabled
  vpc_id                           = var.vpc_id
  target_type                      = "ip" # Hardcoded because `ip` is the only mode supported by fargate
  port                             = var.container_port
  lb_maintenance_mode              = var.lb_maintenance_mode
  lb_maintenance_mode_content_type = var.lb_maintenance_mode_content_type
  lb_maintenance_mode_page_content = var.lb_maintenance_mode_page_content
  lb_maintenance_mode_status_code  = var.lb_maintenance_mode_status_code
}

module "ecs_service_fargate_elb" {
  source = "/deployer/modules/ecs_service_fargate_elb"

  command               = var.command
  container_port        = var.container_port
  cpu                   = var.cpu
  desired_count         = var.desired_count
  docker_image_name     = var.docker_image_name
  ecs_cluster_name      = var.ecs_cluster_name
  envars                = var.envars
  environment_name      = var.environment_name
  kms_key_id            = var.kms_key_id
  log_group_name        = module.log_group.log_group_name
  memory                = var.memory
  param_store_namespace = var.param_store_namespace
  security_group_name   = var.security_group_name
  service_name          = var.service_name
  subnets               = var.private_subnets
  target_group_arn      = module.public_load_balancer.target_group_arn
  vpc_cidr              = var.vpc_cidr
  vpc_id                = var.vpc_id

  depends_on_hack = module.public_load_balancer.aws_lb_listener
}

