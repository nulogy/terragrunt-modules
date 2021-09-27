output "data_platform_database_user__username" {
  value = var.data_platform_database_user__username
}

output "data_platform_database_user__password" {
  value     = var.data_platform_database_user__password
  sensitive = true
}

output "data_platform_database_user__events_table" {
  value = var.data_platform_database_user__events_table
}
