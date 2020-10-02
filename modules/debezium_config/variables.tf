variable "environment_name" {}

variable "debezium_config__bootstrap_servers" {}

variable "debezium_config__cluster_url" {}

variable "debezium_config__events_table" {
  default = "message_bus_subscription_events"
}

variable "database_address" {}

variable "database_engine_version" {}

variable "database_name" {}

variable "database_port" {
  default = "5432"
}

variable "heartbeat_query" {
  default = "use default"
}

variable "database_username" {
  default = "debezium"
}

variable "database_password" {}
