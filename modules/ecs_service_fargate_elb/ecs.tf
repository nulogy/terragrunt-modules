locals {
  container_name = "${var.environment_name}_${var.service_name}"
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
    "cpu": ${var.cpu},
    "environment": ${var.envars},
    "essential": true,
    "image": "${var.docker_image_name}",
    "portMappings": [{
      "hostPort": ${var.container_port},
      "containerPort": ${var.container_port},
      "protocol": "tcp"
    }],
    "memoryReservation": ${var.memory},
    "memory": ${var.memory},
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
]
DEFINITION

}

resource "aws_ecs_service" "ecs_service" {
  name            = "${local.container_name}_service"
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  lifecycle {
    ignore_changes = [desired_count]
  }

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

