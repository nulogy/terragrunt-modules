resource "aws_ecs_task_definition" "ecs_task" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  family = "${var.environment_name}_event_shovel_td"
  task_role_arn = "${aws_iam_role.ecs_taskrole.arn}"
  container_definitions = <<DEFINITION
[
  {
    "environment": ${var.envvars},
    "essential": true,
    "image": "${var.docker_image_name}",
    "memoryReservation": ${var.memory_reservation},
    "name": "${var.environment_name}-event-shovel",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.environment_name}-event-shovel"
      }
    }
  },
  {
    "environment": ${var.envvars},
    "essential": true,
    "image": "${var.docker_image_name}",
    "memoryReservation": ${var.memory_reservation},
    "name": "${var.environment_name}-event-shovel-check",
    "links": [
      "${var.environment_name}-event-shovel"
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.environment_name}-event-shovel"
      }
    },
    "command": ["./run_check_queue_size.sh"]
  }
]
DEFINITION

}

resource "aws_ecs_service" "ecs_service" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}_event_shovel_service"
  cluster = "${var.ecs_cluster_name}"
  desired_count = "1"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
}
