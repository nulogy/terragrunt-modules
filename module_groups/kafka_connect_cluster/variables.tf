// Global

variable "aws_region" {
  description = "The AWS Region you want to send everything to. Pick something close to the customer."
}

variable "aws_profile" {
  description = "The AWS account you want to use, as defined by your ~/.aws/credentials file."
}

// Shared

variable "shared_vpc__type" {}

// Dependencies

variable "kms_key_id" {}

variable "ecs_cluster_name" {}

variable "cert_domain" {}
variable "environment_dns_zone_id" {}
variable "environment_dns_zone_name" {}

// Module

variable "kafka_connect__additional_ingress_cidrs" {
  description = "Cidrs used for ingress security groups. For example, for access via a Client VPN. The (Shared) VPC is appended to this list."
  type        = list(string)
  default     = []
}

variable "kafka_connect__bootstrap_servers" {}

variable "kafka_connect__docker_image_name" {
  description = "Docker image to use for Kafka Connect ECS tasks. E.g. an image containing debezium, or the snowflake connector"
  type        = string
  default     = "nulogy/debezium-connect:1.6.2.Final"
}

variable "kafka_connect__ecs_memory" {
  default = 2048
}

variable "kafka_connect__ecs_cpu" {
  default = 1024
}

variable "kafka_connect__cluster_name" {
  description = "A name for the logical cluster. This scopes this Kafka Connect cluster to be independent of others."
  type        = string
}

variable "kafka_connect__task_count" {
  description = "Number of Kafka Connect nodes to run"
  type        = number
  default     = 1
}

variable "additional_envars" {
  description = "List of objects which map to environment variables to pass into the container task. e.g. [{name: MY_ENVAR, value: MY_VALUE}]"
  type        = list(object)
  default     = []
}