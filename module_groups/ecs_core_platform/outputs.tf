output "ecs_cluster_id" {
  value = "${module.ecs_cluster.ecs_cluster_id}"
}

output "ecs_cluster_name" {
  value = "${module.ecs_cluster.ecs_cluster_name}"
}

output "log_group_name" {
  value = "${module.log_group.log_group_name}"
}

output "public_subnet_ids" {
  value = "${module.ecs_subnets.public_subnet_ids}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}