module "ecs_core_platform" {
  source = "../ecs_core_platform"

  desired_capacity    = var.desired_capacity
  ec2_public_key      = var.ec2_public_key
  ecs_ami             = var.ecs_ami
  ecs_ami_owner       = var.ecs_ami_owner
  environment_name    = var.environment_name
  health_check_type   = var.health_check_type
  lc_instance_type    = var.lc_instance_type
  max_size            = var.max_size
  min_size            = var.min_size
  office_ip           = var.office_ip
  peer_account_id     = var.peer_account_id
  peer_vpc_cidr       = var.peer_vpc_cidr
  peer_vpc_id         = var.peer_vpc_id
  private_ecs_subnets = var.private_ecs_subnets
  public_subnets      = var.public_subnets
  vpc_cidr            = var.vpc_cidr
}

module "public_load_balancer" {
  source = "../../modules/public_load_balancer"

  alb_subnets       = module.ecs_core_platform.public_subnet_ids
  cert_domain       = var.cert_domain
  environment_name  = var.environment_name
  health_check_path = var.health_check_path
  vpc_id            = module.ecs_core_platform.vpc_id
}

module "route53_for_load_balancer" {
  source = "../../modules/route53_alias_record"

  domain         = var.route53_domain
  subdomain      = var.route53_subdomain
  target_domain  = module.public_load_balancer.dns_name
  target_zone_id = module.public_load_balancer.zone_id
}

