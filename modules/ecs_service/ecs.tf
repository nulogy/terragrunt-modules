data "template_file" "template" {
  template = "${file(var.task_definition_json)}"

  vars {
    TPL_COMMAND = "${join("\",\"", var.command)}"
    TPL_CONTAINER_PORT = "${var.container_port}"
    TPL_CPU = "${var.cpuReservation}"
    TPL_DOCKER_IMAGE = "${var.docker_image_name}"
    TPL_ENV_NAME = "${var.environment_name}"
    TPL_ENVVARS = "${var.envars}"
    TPL_LOG_GROUP_NAME = "${var.log_group_name}"
    TPL_MEM = "${var.max_memory}"
    TPL_MEM_RESERVATION = "${var.memory_reservation}"
    TPL_REGION = "${var.aws_region}"
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  family = "${var.environment_name}_td"
  task_role_arn = "${aws_iam_role.ecs_taskrole.arn}"
  container_definitions = "${data.template_file.template.rendered}"
}

resource "aws_ecs_service" "ecs_service" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}_service"
  cluster = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  desired_count = "${var.desired_count}"
  iam_role = "${aws_iam_role.ecs_servicerole.arn}"

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.environment_name}"
    container_port = "${var.container_port}"
  }

  ordered_placement_strategy {
    type = "spread"
    field = "attribute:ecs.availability-zone"
  }
}
