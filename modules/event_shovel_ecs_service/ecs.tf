resource "aws_ecs_task_definition" "ecs_task" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  cpu = "${var.cpu}"
  memory = "${var.memory_reservation}"
  family = "${var.environment_name}_event_shovel_td"
  task_role_arn = "${aws_iam_role.ecs_taskrole.arn}"
  execution_role_arn = "${aws_iam_role.ecs_executionrole.arn}"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  container_definitions = <<DEFINITION
[
  {
    "environment": ${var.envvars},
    "essential": true,
    "image": "${var.docker_image_name}",
    "name": "${var.environment_name}-event-shovel",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.log_group_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.environment_name}-event-shovel"
      }
    }
  }
]
DEFINITION

}

resource "aws_ecs_service" "ecs_service" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}_event_shovel_service"
  cluster = "${var.ecs_cluster_name}"
  desired_count = "${var.desired_count}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  launch_type = "FARGATE"

  network_configuration {
    subnets = ["${var.private_subnet_ids}"]
    security_groups = ["${aws_security_group.event_shovel.id}"]
  }
}
