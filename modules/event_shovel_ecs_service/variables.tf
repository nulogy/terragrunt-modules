variable "aws_account" {}
variable "aws_region" {}
variable "docker_image_name" {}
variable "ecs_cluster_name" {}
variable "environment_name" {}
variable "envvars" {}
variable "kms_key_id" { default = "" }
variable "log_group_name" {}
variable "memory_reservation" {}
variable "param_store_namespace" {}
variable "redis_memory_reservation" {}
variable "skip" { default = "" }
