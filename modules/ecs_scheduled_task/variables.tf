variable "alerts_topic_name" {}
variable "aws_account" {}
variable "aws_region" {}
variable "container_definitions" {}
variable "container_port" {}
variable "db_username" {}
variable "docker_image_name" {}
variable "ecs_cloudwatch_log_group_name" {}
variable "ecs_cluster_name" {}
variable "ecs_task_arn" {}
variable "encrypted_storage" {}
variable "environment_name" {}
variable "kms_key_id" {}
variable "rds_address" {}
variable "rds_db_name" {}
variable "rds_port" {}
variable "skip" { default = "" }
variable "target_group_arn" {}
