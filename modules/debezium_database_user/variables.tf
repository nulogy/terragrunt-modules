variable "database_address" {}

variable "postgres_version" {
  default = "latest"
}

variable "database_name" {}

variable "database_port" {
  default = "5432"
}

variable "debezium_events_table" {
  default = "message_bus_subscription_events"
}

variable "debezium_password" {}

variable "debezium_username" {
  default = "debezium"
}

variable "database_admin_username" {}

variable "database_admin_password" {}
