variable "alert_topic_arn" {}
variable "alert_evaluation_periods" { default = "1" }
variable "aws_account" {}
variable "aws_region" {}

variable "cpu" {
  default = "512"
  description = "CPU allocation per container. 256 is 0.25 vCPU."
}

variable "desired_count" {}
variable "docker_image_name" {}
variable "ecs_cluster_name" {}
variable "environment_name" {}
variable "envvars" {}
variable "kms_key_id" { default = "" }
variable "log_group_name" {}

variable "memory_reservation" {
  description = "How much memory to allocate to each container in MiB."
  default = "1024"
}

variable "param_store_namespace" {}
variable "skip" { default = "" }

variable "private_subnet_ids" {
  description = "Determines the AZ for the containers."
  type = "list"
}

variable "queue_threshold" {
  description = "How many events are queued before an alert goes out."
  default = 100
}

variable "vpc_id" {
  description = "The VPC that this task should live in."
}
