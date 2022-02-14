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

variable "max_record_count" {
  description = "Trigger Snowpipe with a file that contains this many records (Note: size or time may trigger this first)"
  default = 1000
}

variable "max_buffer_size" {
  description = "Trigger Snowpipe with a file that contains this many bytes (Note: record count or time may trigger this first)"
  default = 5000000
}

variable "flush_time" {
  description = "Trigger Snowpipe after this many seconds if max count nor size has been reached"
  default = 60
}

variable "target_schema" {
  description = "Ingest data into this schema"
  default = "PUBLIC"
}

variable "target_table" {
  description = "Ingest data into this table"
  default = "INBOX"
}

variable "tasks_count" {
  description = "The connector can run this many tasks as a time"
  default = 4
}
