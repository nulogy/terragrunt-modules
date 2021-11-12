variable "environment_name" {
}

variable "connector_name" {
  type = string
  description = "Name for the Kafka Connect connector.  Use kabab-case."
}

variable "kafka_connect_url" {
  description = "URL, including https://, of Kafka Connect to run the connector on"
  type = string
}

variable "kafka_topic" {
  type        = string
  description = "Comma-separated list of topics to sync to Snowflake"
}

variable "snowflake_url" {
  type        = string
  description = "The full URL for accessing Snowflake.  Protocol and port are optional"
}

variable "snowflake_username" {
  type        = string
  description = "Username to use with this Snowflake connector"
}

variable "snowflake_database" {
  type        = string
  description = "The name of the database that contains the table to insert rows into"
}
