resource "null_resource" "postgres_publication" {
  triggers = {
    database_address        = var.database_address
    database_name           = var.database_name
    database_port           = var.database_port
    events_table            = var.events_table
    database_admin_password = var.database_admin_password
    database_admin_username = var.database_admin_username
    postgres_version        = var.postgres_version
    publication_name        = var.publication_name
  }

  provisioner "local-exec" {
    command = <<EOF
docker run -e PGPASSWORD="${self.triggers.database_admin_password}" --rm --entrypoint="" postgres:${self.triggers.postgres_version}-alpine \
  psql \
  --host ${self.triggers.database_address} \
  --port ${self.triggers.database_port} \
  --username ${self.triggers.database_admin_username} \
  --dbname "${self.triggers.database_name}" \
  --command "
CREATE PUBLICATION debezium_public_events FOR TABLE  WITH (publish = 'insert');
  DO $$BEGIN
    IF NOT EXISTS(SELECT FROM pg_publication WHERE pubname = 'self.triggers.publication_name')
    THEN
      CREATE PUBLICATION debezium_public_events
      FOR TABLE ${self.triggers.events_table}
      WITH (publish = 'insert');;
    END IF;;
  END$$;
"
EOF
  }
}