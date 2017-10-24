resource "aws_ecs_task_definition" "go_task" {
  family = "${var.environment_name}_td"
  task_role_arn = "${aws_iam_role.ecs_taskrole.arn}"
  depends_on = ["aws_iam_role.ecs_taskrole"]
  container_definitions = <<DEFINITION
[
  {
    "cpu": 0,
    "environment": [
      {
        "name": "GO_DATABASE_HOST",
        "value": "${var.rds_address}"
      },
      {
        "name": "GO_DATABASE_PORT",
        "value": "${var.rds_port}"
      },
      {
        "name": "GO_DATABASE_USER",
        "value": "${var.rds_db_username}"
      },
      {
        "name": "GO_DATABASE_NAME",
        "value": "${var.rds_db_name}"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${var.aws_region}"
      },
      {
        "name": "FETCH_PARAMETERS",
        "value": "true"
      },
      {
        "name": "ENVIRONMENT_NAME",
        "value": "${var.environment_name}"
      }
    ],
    "essential": true,
    "image": "${var.docker_image_name}",
    "memoryReservation": 450,
    "name": "${var.environment_name}",
    "portMappings": [{
      "hostPort": 0,
      "containerPort": 8080,
      "protocol": "tcp"
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${var.ecs_cloudwatch_log_group_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "go-app-container"
      }
    }
  }
]
DEFINITION

}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.environment_name}_service"
  cluster = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.go_task.arn}"
  desired_count = 2
  iam_role = "${aws_iam_role.ecs_servicerole.arn}"
  depends_on= ["aws_iam_role.ecs_servicerole"]

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.environment_name}"
    container_port = 8080
  }
}
