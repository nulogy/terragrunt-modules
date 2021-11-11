locals {
}

data "template_file" "snowflake_connector_config" {
  template = file("${path.module}/snowflake-connector-config.tpl")

  vars = {
    connector_name                   = var.connection_name
    kafka_topic                      = var.kafka_topic
    snowflake_database               = var.snowflake_database
    snowflake_private_key            = var.snowflake_private_key
    snowflake_private_key_passphrase = var.snowflake_private_key_passphrase
    snowflake_url                    = var.snowflake_url
    snowflake_username               = var.snowflake_username
  }
}

resource "local_file" "json" {
  sensitive_content = data.template_file.snowflake_connector_config.rendered
  filename          = "${path.module}/snowflake-connector-config.json"
}

resource "null_resource" "upload_config" {
  triggers = {
    cluster_url     = var.kafka_connect_url
    connection_name = var.connection_name
  }

  provisioner "local-exec" {
    command = <<EOF
curl -X PUT -H "Accept:application/json" -H "Content-Type:application/json" \
  -d "@${local_file.json.filename}" \
  ${self.triggers.cluster_url}/connectors/${self.triggers.connection_name}/config
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
curl --output /dev/null --fail -X DELETE -H "Accept:application/json" -H "Content-Type:application/json" \
  ${self.triggers.cluster_url}/connectors/${self.triggers.connection_name}
# Try to wait until the resource is actually destroyed. This can cause problems when uploading a new config
# and terraform does a destroy then a create. This should probably be replaced with some kind of API polling.
sleep 2.0
EOF
  }
}
