output "autoscaling_group_name" {
  value = module.ecs_auto_scaling_group.autoscaling_group_name
}

output "ecs_cluster_id" {
  value = module.ecs_cluster.ecs_cluster_id
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.ecs_cluster_name
}

output "ecs_cluster_arn" {
  value = module.ecs_cluster.ecs_cluster_arn
}
