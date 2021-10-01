locals {
  docker_image = var.postgres_version == "latest" ? "postgres:alpine" : "postgres:${var.postgres_version}-alpine"

  grant_command = <<EOF
docker run -e PGPASSWORD="${var.database_admin_password}" --rm --entrypoint="" ${local.docker_image} \
  psql \
  --host ${var.database_address} \
  --port ${var.database_port} \
  --username ${var.database_admin_username} \
  --dbname "${var.database_name}" \
  --command "
    CREATE ROLE ${var.debezium_username} with LOGIN PASSWORD
    '${var.debezium_password}' VALID UNTIL 'infinity' IN ROLE rds_replication;
    GRANT USAGE ON SCHEMA public TO debezium;
    GRANT SELECT, INSERT, DELETE ON TABLE ${var.debezium_events_table} TO ${var.debezium_username};
    ${var.debezium_database_user__additional_grant_statements}
  "
EOF

  revoke_command = <<EOF
docker run -e PGPASSWORD="${var.database_admin_password}" --rm --entrypoint="" ${local.docker_image} \
  psql \
  --host ${var.database_address} \
  --port ${var.database_port} \
  --username ${var.database_admin_username} \
  --dbname "${var.database_name}" \
  --command "
    ${var.debezium_database_user__additional_revoke_statements}
    REVOKE ALL PRIVILEGES ON TABLE ${var.debezium_events_table} FROM ${var.debezium_username};
    REVOKE USAGE ON SCHEMA public FROM debezium;
    REVOKE CREATE ON DATABASE ${var.database_name} FROM ${var.debezium_username};
    DROP ROLE ${var.debezium_username};
  "
EOF
}

resource "null_resource" "create_debezium_user" {
  triggers = {
    role           = var.debezium_username
    grant_command  = local.grant_command
    revoke_command = local.revoke_command
  }

  provisioner "local-exec" {
    command = self.triggers.grant_command
  }

  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.revoke_command
  }
}
