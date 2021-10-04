locals {
  docker_image = var.postgres_version == "latest" ? "postgres:alpine" : "postgres:${var.postgres_version}-alpine"

  psql_command = <<EOF
    docker run -e PGPASSWORD="${var.database_admin_password}" --rm --entrypoint="" ${local.docker_image} \
      psql \
      --host ${var.database_address} \
      --port ${var.database_port} \
      --username ${var.database_admin_username} \
      --dbname ${var.database_name} \
EOF

  grant_command = "${local.psql_command} --command \"${data.template_file.grant_usage_in_ops_query.rendered};\""

  revoke_command = "${local.psql_command} --command \"${data.template_file.drop_user_in_ops_query.rendered};\""
}

data "template_file" "grant_usage_in_ops_query" {
  template = file("${path.module}/grant_usage_in_ops.sql.tpl")
  vars     = {
     data_platform_database_user__username = var.data_platform_database_user__username
     data_platform_database_user__password = var.data_platform_database_user__password
  }
}

data "template_file" "drop_user_in_ops_query" {
  template = file("${path.module}/drop_user_in_ops.sql.tpl")
  vars     = {
     data_platform_database_user__username = var.data_platform_database_user__username
  }
}

resource "null_resource" "create_data_platform_database_user__user" {
  triggers = {
    role           = var.data_platform_database_user__username
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
