variable "database_address" {}

variable "database_engine_version" {}

variable "database_name" {}

variable "database_port" {
  default = "5432"
}

variable "granter_username" {}

variable "granter_password" {}

variable "debezium_events_table" {
  default = "message_bus_subscription_events"
}

variable "debezium_password" {}

variable "debezium_username" {
  default = "debezium"
}
