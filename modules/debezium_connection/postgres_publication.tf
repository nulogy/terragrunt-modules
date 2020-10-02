locals {
  docker_image = var.postgres_version == "latest" ? "postgres:alpine" : "postgres:${var.postgres_version}-alpine"

  idempotent_create_publication = <<EOF
docker run -e PGPASSWORD="${var.database_admin_password}" --rm --entrypoint="" ${local.docker_image} \
  psql \
  --host ${var.database_address} \
  --port ${var.database_port} \
  --username ${var.database_admin_username} \
  --dbname "${var.database_name}" \
  --command "
  DO \$\$BEGIN
    IF NOT EXISTS(SELECT FROM pg_publication WHERE pubname = '${var.publication_name}')
    THEN
      CREATE PUBLICATION ${var.publication_name}
      FOR TABLE ${var.events_table}
      WITH (publish = 'insert');
    END IF;
  END\$\$
"
EOF
}

resource "null_resource" "postgres_publication" {
  triggers = {
    idempotent_create_publication = local.idempotent_create_publication
  }

  provisioner "local-exec" {
    command = self.triggers.idempotent_create_publication
  }
}