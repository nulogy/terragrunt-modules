output "rds_address" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_db_instance.db.*.address, list("")), 0)}"
}

output "rds_port" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_db_instance.db.*.port, list("")), 0)}"
}
