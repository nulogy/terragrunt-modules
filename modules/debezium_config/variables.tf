variable "aws_region" {
  description = "The AWS Region you want to send everything to. Pick something close to the customer."
}

variable "aws_profile" {
  description = "The AWS account you want to use, as defined by your ~/.aws/credentials file."
}

variable "environment_name" {
}

variable "debezium_config__bootstrap_servers" {}

variable "debezium_config__cluster_url" {}

variable "debezium_config__config_name" {}

variable "debezium_config__events_table" {
  default = "message_bus_subscription_events"
}

variable "database_address" {}

variable "database_engine_version" {}

variable "database_name" {}

variable "database_port" {
  default = "5432"
}

variable "database_user" {}

variable "heartbeat_query" {
  default = "use default"
}