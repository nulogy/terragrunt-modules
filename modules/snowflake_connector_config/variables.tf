variable "kafka_connect_url" {
  type = string
}

variable "kafka_topics" {
  type = string
  description = "Comma-separated list of topics to sync to Snowflake"
}

variable "snowflake_url_name" {
  type = string
  description = "The full URL for accessing Snowflake.  Protocol and port are optional"
}

variable "snowflake_username" {
  type = string
  description = "Username to use with this Snowflake connector"
}

variable "snowflake_private_key" {
  type = string
  description = "The private key to authenticate the user. Include only the key, not the header or footer."
}

variable "snowflake_private_key_passphrase" {
  type = string
  description = "The passphrase to decrypt the private key"
}

variable "snowflake_database_name" {
  type = string
  description = "The name of the database that contains the table to insert rows into"
}
