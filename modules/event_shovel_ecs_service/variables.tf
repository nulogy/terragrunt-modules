variable "alert_topic_arn" {}
variable "alert_evaluation_periods" {}
variable "aws_account" {}
variable "aws_region" {}
variable "desired_count" {}
variable "docker_image_name" {}
variable "ecs_cluster_name" {}
variable "environment_name" {}
variable "envvars" {}
variable "kms_key_id" { default = "" }
variable "log_group_name" {}
variable "memory_reservation" { default = "500" }
variable "param_store_namespace" {}
variable "skip" { default = "" }
