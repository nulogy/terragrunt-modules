resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
}
