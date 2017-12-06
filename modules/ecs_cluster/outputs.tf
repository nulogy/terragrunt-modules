output "ecs_cluster_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_cluster.ecs_cluster.*.name, list("")), 0)}"
}

output "ecs_cluster_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_cluster.ecs_cluster.*.id, list("")), 0)}"
}
