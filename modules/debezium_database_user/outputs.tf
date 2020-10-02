output "debezium_username" {
  value = var.debezium_username
}

output "debezium_password" {
  value     = var.debezium_password
  sensitive = true
}

output "debezium_events_table" {
  value = var.debezium_events_table
}
