variable "connection_name" {}

variable "database_address" {}

variable "database_name" {}

variable "database_port" {
  default = "5432"
}

variable "database_username" {
  default = "debezium"
}

variable "database_password" {}

variable "debezium_events_table" {
  default = "message_bus_subscription_events"
}

variable "heartbeat_query" {
  default = "use default"
}

variable "kafka_bootstrap_servers" {}

variable "kafka_connect_url" {}
