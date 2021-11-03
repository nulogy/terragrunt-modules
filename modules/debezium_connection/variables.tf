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
  description = "The database table where subscription events are written to. Configurable in the Message Bus Producer gem."
  type        = string
  default     = "message_bus_subscription_events"
}

variable "kafka_bootstrap_servers" {
  type = string
}

variable "kafka_connect_url" {
  type = string
}

variable "postgres_version" {
  description = "Version of Postgres to use when executing statements from a Docker image. Using the same major version should be sufficient. e.g. 11.5"
  type        = string
  default     = "latest"
}

variable "publication_name" {
  type    = string
  default = "debezium_public_events"
}

variable "replication_slot_name_override" {
  description = "Override the default (computed) name of the replication slot to use. Helpful in recovery scenarios."
  type        = string
  default     = ""
}

variable "subscription_events_ttl" {
  type        = string
  description = "Delete older Message Bus subscription events older than this value. Must be a string passable to the SQL INTERVAL function."
  default     = "7 days"
}

variable "postgres_search_paths" {
  description = "The search_path to use when executing a heartbeat."
  type        = list(string)
  default     = ["public"]
}
