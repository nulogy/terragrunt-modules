locals {
  container_name              = "${var.environment_name}_${var.service_name}"
  health_check_object         = length(var.health_check_command) > 0 ? jsonencode({ command : var.health_check_command }) : "null"

  ## datadog will subtract from task allocated cpu and memory, please adjust var.cpu and/or var.memory to accommodate if necessary
  container_cpu               = var.cpu    - (local.datadog_agent_cpu)
  container_memory            = var.memory - (local.datadog_agent_memoryReservation)
  container_memoryReservation = var.memory - (local.datadog_agent_memory)

  ## cpu/memory values based on:
  ## https://nulogy-go.atlassian.net/wiki/spaces/SRE/pages/743604360/2020-Q2+Replace+New+Relic+with+Datadog#Resource-Allocation-for-Datadog-Agent
  ## https://aws.amazon.com/fargate/pricing/
  datadog_enabled                 = length(var.datadog_api_key) > 0 ? 1 : 0
  datadog_agent_cpu               = local.datadog_enabled * ((log((var.cpu/256),2)*16) + 64) ## [64..128]
  datadog_agent_memoryReservation = local.datadog_enabled * 128
  datadog_agent_memory            = local.datadog_enabled * ((log((var.cpu/256),2)*32) + 128) ## [128..256]
  datadog_envars                  = <<EOF
  [
    {
      "name": "DD_API_KEY",
      "value": "${var.datadog_api_key}"
    },
    {
      "name": "DD_APM_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_APM_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "ECS_FARGATE",
      "value": "true"
    },
    {
      "name": "DD_TAGS",
      "value": "env:${var.environment_name}:${var.service_name}"
    }
  ]
EOF
}

resource "aws_ecs_task_definition" "ecs_task" {
  cpu                      = var.cpu
  memory                   = var.memory
  family                   = "${var.environment_name}_${var.service_name}_td"
  task_role_arn            = aws_iam_role.ecs_taskrole.arn
  execution_role_arn       = aws_iam_role.ecs_executionrole.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = <<DEFINITION
[
  {
    "command": ["${join("\",\"", var.command)}"],
    "cpu": ${local.container_cpu},
    "environment": ${var.envars},
    "essential": true,
    "healthCheck": ${local.health_check_object},
    "image": "${var.docker_image_name}",
    "portMappings": [{
      "hostPort": ${var.container_port},
      "containerPort": ${var.container_port},
      "protocol": "tcp"
    }],
    "memoryReservation": ${local.container_memoryReservation},
    "memory": ${local.container_memory},
    "name": "${local.container_name}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "${var.environment_name}"
      }
    }
  }
  %{ if local.datadog_enabled > 0 }
  ,{
    "cpu": ${local.datadog_agent_cpu},
    "environment": ${local.datadog_envars},
    "essential": true,
    "image": "datadog/agent:${var.datadog_agent_version}",
    "portMappings": [{
      "hostPort": 8126,
      "containerPort": 8126,
      "protocol": "tcp"
    }],
    "memoryReservation": ${local.datadog_agent_memoryReservation},
    "memory": ${local.datadog_agent_memory},
    "name": "${local.container_name}-datadog",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "${var.environment_name}"
      }
    }
  }
  %{ endif }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${local.container_name}_service"
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.app_worker.id]
  }

  depends_on = [null_resource.alb_exists]
}

resource "null_resource" "alb_exists" {
  triggers = {
    alb_name = var.depends_on_hack
  }
}
