locals {
  task_def_json  = length(var.task_definition_json) > 0 ? var.task_definition_json : "${path.module}/task_definition/default.json"
  container_name = "${var.environment_name}_${var.service_name}"
}

data "template_file" "template" {
  template = file(local.task_def_json)

  vars = {
    TPL_CPU             = var.cpu
    TPL_DOCKER_IMAGE    = var.docker_image_name
    TPL_ENV_NAME        = var.environment_name
    TPL_SERVICE_NAME    = var.service_name
    TPL_CONTAINER_NAME  = local.container_name
    TPL_LOG_GROUP_NAME  = var.log_group_name
    TPL_REGION          = data.aws_region.current.name
    TPL_ENVVARS         = var.envars
    TPL_MEM_RESERVATION = var.memory / var.containers_per_task
    TPL_MEM             = var.memory / var.containers_per_task
    TPL_COMMAND         = join("\",\"", var.command)
    TPL_HEALTH_CHECK    = join("\",\"", var.health_check)
  }
}

data "aws_service_discovery_dns_namespace" "private_dns_namespace" {
  name = var.ecs_cluster_name
  type = "DNS_PRIVATE"
}

resource "aws_ecs_task_definition" "ecs_task" {
  cpu                      = var.cpu
  memory                   = var.memory
  family                   = "${var.environment_name}_${var.service_name}_td"
  task_role_arn            = aws_iam_role.ecs_taskrole.arn
  execution_role_arn       = aws_iam_role.ecs_executionrole.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions    = data.template_file.template.rendered
}

resource "aws_service_discovery_service" "discovery_service" {
  name = "${var.environment_name}_${var.service_name}"

  dns_config {
    namespace_id = data.aws_service_discovery_dns_namespace.private_dns_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

resource "aws_ecs_service" "ecs_service" {
  name                   = "${var.environment_name}_${var.service_name}_service"
  cluster                = var.ecs_cluster_name
  task_definition        = aws_ecs_task_definition.ecs_task.arn
  launch_type            = "FARGATE"
  desired_count          = var.desired_count
  enable_execute_command = true

  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }
}
