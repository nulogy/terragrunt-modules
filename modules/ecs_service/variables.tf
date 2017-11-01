variable "aws_account" {}
variable "aws_region" {}
variable "container_port" {}
variable "cpuReservation" {}
variable "desired_count" {}
variable "docker_image_name" {}
variable "ecs_cluster_name" {}
variable "envars" {}
variable "environment_name" {}
variable "kms_key_id" { default = ""}
variable "log_group_name" {}
variable "memoryReservation" {}
variable "parameter_namespace" {}
variable "target_group_arn" {}
