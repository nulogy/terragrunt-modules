output "rds_address" {
  value = "${module.postgres_rds.rds_address}"
}

output "rds_port" {
  value = "${module.postgres_rds.rds_port}"
}
