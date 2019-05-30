output "ecs_cluster_id" {
  value = "${module.ecs_core_platform.ecs_cluster_id}"
}

output "ecs_cluster_name" {
  value = "${module.ecs_core_platform.ecs_cluster_name}"
}

output "log_group_name" {
  value = "${module.ecs_core_platform.log_group_name}"
}

output "public_load_balancer_fqdn" {
  value = "${var.route53_subdomain}.${var.route53_domain}"
}

output "target_group_arn" {
  value = "${module.public_load_balancer.target_group_arn}"
}

output "vpc_id" {
  value = "${module.ecs_core_platform.vpc_id}"
}

output "private_subnet_ids" {
  value = "${module.ecs_core_platform.private_subnet_ids}"
}
