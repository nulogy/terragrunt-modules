locals {
  container_name              = "${var.environment_name}_${var.service_name}"
  health_check_object         = length(var.health_check_command) > 0 ? jsonencode({ command : var.health_check_command }) : "null"

  ## datadog will subtract from task allocated cpu and memory, please adjust var.cpu and/or var.memory to accommodate if necessary
  container_cpu               = var.cpu    - (local.datadog_agent_cpu)
  container_memory            = var.memory - (local.datadog_agent_memoryReservation)
  container_memoryReservation = var.memory - (local.datadog_agent_memory)

  ## injects datadog service name env var in the app
  container_datadog_envars = var.datadog_enabled ? [
    {
      "name": "DD_ENV",
      "value": "${var.datadog_env}"
    },
    {
      "name": "DD_SERVICE",
      "value": "${local.datadog_service}"
    },
    {
      "name": "DD_VERSION",
      "value": "${var.docker_image_name}"
    }
  ] : []
  container_envars            = jsonencode(concat(jsondecode(var.envars),
    local.container_datadog_envars
  ))

  ## cpu/memory values based on:
  ## https://nulogy-go.atlassian.net/wiki/spaces/SRE/pages/743604360/2020-Q2+Replace+New+Relic+with+Datadog#Resource-Allocation-for-Datadog-Agent
  ## https://aws.amazon.com/fargate/pricing/
  datadog_service                 = "${var.environment_name}/${var.service_name}"
  datadog_agent_cpu               = var.datadog_enabled ? ((log((var.cpu/256),2)*16) + 64) : 0 ## [64..128]
  datadog_agent_memoryReservation = var.datadog_enabled ? 128 : 0
  datadog_agent_memory            = var.datadog_enabled ? ((log((var.cpu/256),2)*32) + 128) : 0 ## [128..256]
  ## https://docs.datadoghq.com/agent/docker/?tab=standard#global-options
  datadog_agent_envars            = <<EOF
  [
    {
      "name": "DD_LOG_LEVEL",
      "value": "warn"
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
      "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "DD_ENV",
      "value": "${var.datadog_env}"
    },
    {
      "name": "DD_SERVICE",
      "value": "${local.datadog_service}"
    },
    {
      "name": "DD_VERSION",
      "value": "${var.docker_image_name}"
    },
    {
      "name": "ECS_FARGATE",
      "value": "true"
    },
    {
      "name": "DD_CONTAINER_EXCLUDE",
      "value": "image:fg-proxy"
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
    "environment": ${local.container_envars},
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
  %{ if var.datadog_enabled }
  ,{
    "cpu": ${local.datadog_agent_cpu},
    "environment": ${local.datadog_agent_envars},
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
    },
    "secrets": [
      {
        "name": "DD_API_KEY",
        "valueFrom": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.param_store_namespace}/datadog/api-key"
      }
    ]
  }
  %{ endif }
]
DEFINITION
}

//resource "aws_ecs_service" "ecs_service" {
//  name            = "${local.container_name}_service"
//  cluster         = var.ecs_cluster_name
//  task_definition = aws_ecs_task_definition.ecs_task.arn
//  launch_type     = "FARGATE"
//  desired_count   = var.desired_count
//
//  load_balancer {
//    target_group_arn = var.target_group_arn
//    container_name   = local.container_name
//    container_port   = var.container_port
//  }
//
//  network_configuration {
//    subnets         = var.subnets
//    security_groups = [aws_security_group.app_worker.id]
//  }
//}

resource "aws_ecs_service" "ecs_service_tmp" {
  name            = "${local.container_name}_service_tmp"
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = var.target_group_arn_tmp
    container_name   = local.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.app_worker.id]
  }
}
