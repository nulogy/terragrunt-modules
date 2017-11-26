module "ecr" {
  source = "../../modules/ecr"
  skip = "${var.skip}"

  name = "${var.environment_name}"
}

module "ecs_service" {
  source = "../../modules/ecs_service"
  skip = "${var.skip}"

  aws_account = "${var.aws_account}"
  aws_region = "${var.aws_region}"
  container_port = "${var.container_port}"
  cpuReservation = "${var.cpuReservation}"
  desired_count = "${var.desired_count}"
  docker_image_name = "${module.ecr.ecr_url}:${var.docker_image_build_tag}"
  ecs_cluster_name = "${var.ecs_cluster_name}"
  envars = "${var.envars}"
  environment_name = "${var.environment_name}"
  kms_key_id = "${var.kms_key_id}"
  log_group_name = "${var.log_group_name}"
  memoryReservation = "${var.memoryReservation}"
  param_store_namespace = "${var.param_store_namespace}"
  target_group_arn = "${var.target_group_arn}"
}