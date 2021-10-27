resource "aws_service_discovery_private_dns_namespace" "private_dns_namespace" {
  name        = var.name
  description = "${var.name} DNS namespace"
  vpc         = var.vpc_id
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
}