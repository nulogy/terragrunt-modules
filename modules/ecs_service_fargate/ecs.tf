resource "aws_ecs_task_definition" "ecs_task" {
  cpu = "${var.cpu}"
  memory = "${var.memory}"
  family = "${var.environment_name}_td"
  task_role_arn = "${aws_iam_role.ecs_taskrole.arn}"
  execution_role_arn = "${aws_iam_role.ecs_executionrole.arn}"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  container_definitions = <<DEFINITION
[
  {
    "command": ["/bin/bash", "-c", "${var.command}"],
    "cpu": ${var.cpu},
    "environment": ${var.envars},
    "essential": true,
    "image": "${var.docker_image_name}",
    "memoryReservation": ${var.memory},
    "memory": ${var.memory},
    "name": "${var.environment_name}",
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
  name = "${var.environment_name}_service"
  cluster = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  launch_type = "FARGATE"
  desired_count = "${var.desired_count}"

  lifecycle {
    ignore_changes = [ "desired_count" ]
  }

  network_configuration {
    subnets = ["${var.subnets}"]
    security_groups = ["${var.security_groups}"]
  }
}
