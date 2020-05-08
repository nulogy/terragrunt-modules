output "rds_address" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = element(concat(aws_db_instance.db.*.address, [""]), 0)
}

output "rds_port" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = element(concat(aws_db_instance.db.*.port, [""]), 0)
}

