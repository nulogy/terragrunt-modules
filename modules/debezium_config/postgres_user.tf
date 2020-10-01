data "aws_ssm_parameter" "db_password" {
  name = "/${var.environment_name}/RDS/db-password"
}

data "aws_ssm_parameter" "debezium_db_password" {
  name = "/${var.environment_name}/RDS/debezium-db-password"
}

locals {
  grant_command = <<EOF
docker run -e PGPASSWORD="${data.aws_ssm_parameter.db_password.value}" --rm --entrypoint="" postgres:${var.database_engine_version}-alpine \
  psql \
  --host ${var.database_address} \
  --port ${var.database_port} \
  --username ${var.database_user} \
  --dbname "${var.database_name}" \
  --command "CREATE ROLE ${local.debezium_user_name} with LOGIN PASSWORD
    '${data.aws_ssm_parameter.debezium_db_password.value}' VALID UNTIL 'infinity' IN ROLE rds_replication;
    GRANT USAGE ON SCHEMA public TO debezium;
    GRANT SELECT, INSERT, DELETE ON TABLE ${var.debezium_config__events_table} TO ${local.debezium_user_name};
    CREATE PUBLICATION debezium_public_events FOR TABLE ${var.debezium_config__events_table} WITH (publish = 'insert'); "
EOF

  revoke_command = <<EOF
docker run -e PGPASSWORD="${data.aws_ssm_parameter.db_password.value}" --rm --entrypoint="" postgres:${var.database_engine_version}-alpine \
  psql \
  --host ${var.database_address} \
  --port ${var.database_port} \
  --username ${var.database_user} \
  --dbname "${var.database_name}" \
  --command "REVOKE ALL PRIVILEGES ON TABLE ${var.debezium_config__events_table} FROM ${local.debezium_user_name};
    REVOKE USAGE ON SCHEMA public FROM debezium;
    REVOKE CREATE ON DATABASE ${var.database_name} FROM ${local.debezium_user_name};
    DROP ROLE ${local.debezium_user_name};"
EOF
}

resource "null_resource" "create_debezium_user" {
  triggers = {
    role           = local.debezium_user_name
    grant_command  = local.grant_command
    revoke_command = local.revoke_command
  }

  provisioner "local-exec" {
    command = self.triggers.grant_command
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = self.triggers.revoke_command
  }
}