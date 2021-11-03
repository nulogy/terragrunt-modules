resource "null_resource" "postgres_initial_heartbeat" {
  provisioner "local-exec" {
    command = <<EOF
docker run -e PGPASSWORD="${var.database_admin_password}" --rm --entrypoint="" ${local.pg_docker_image} \
  psql \
  --host ${var.database_address} \
  --port ${var.database_port} \
  --username ${var.database_admin_username} \
  --dbname "${var.database_name}" \
  --command "
  DO \$\$BEGIN
    ${local.heartbeat_query}
  END\$\$
"
EOF
  }
}
