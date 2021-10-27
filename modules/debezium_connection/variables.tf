variable "connection_name" {
  type = string
}

variable "database_address" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_port" {
  type    = string
  default = "5432"
}

variable "database_admin_password" {
  type = string
}

variable "database_admin_username" {
  type = string
}

variable "database_username" {
  type    = string
  default = "debezium"
}

variable "database_password" {
  type = string
}

variable "events_table" {
  type    = string
  default = "message_bus_subscription_events"
}

variable "heartbeat_query" {
  type    = string
  default = "use default"
}

variable "kafka_bootstrap_servers" {
  type = string
}

variable "kafka_connect_url" {
  type = string
}

variable "postgres_version" {
  type    = string
  default = "latest"
}

variable "publication_name" {
  type    = string
  default = "debezium_public_events"
}

variable "replication_slot_name_override" {
  type    = string
  default = ""
}
