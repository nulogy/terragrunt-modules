variable "aws_account" {}
variable "aws_region" {}
variable "container_port" {}
variable "cpuReservation" {}
variable "desired_count" {}
variable "docker_image_build_tag" {}
variable "ecs_cluster_name" {}
variable "envars" {}
variable "environment_name" {}
variable "kms_key_id" { default = ""}
variable "log_group_name" {}
variable "memoryReservation" {}
variable "param_store_namespace" { default = "" }
variable "skip" { default = "" }
variable "target_group_arn" {}

