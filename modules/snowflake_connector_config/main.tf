data "aws_ssm_parameter" "snowflake_private_key" {
  name = "/${var.environment_name}/data-platform/${var.connector_name}/snowflake-private-key"
}

data "aws_ssm_parameter" "snowflake_private_key_passphrase" {
  name = "/${var.environment_name}/data-platform/${var.connector_name}/snowflake-private-key-passphrase"
}

data "template_file" "snowflake_connector_config" {
  template = file("${path.module}/snowflake-connector-config.tpl")

  vars = {
    connector_name                   = var.connector_name
    kafka_topic                      = var.kafka_topic
    snowflake_database               = var.snowflake_database
    snowflake_private_key            = data.aws_ssm_parameter.snowflake_private_key.value
    snowflake_private_key_passphrase = data.aws_ssm_parameter.snowflake_private_key_passphrase.value
    snowflake_url                    = var.snowflake_url
    snowflake_username               = var.snowflake_username
    max_record_count                 = var.max_record_count
    max_buffer_size                  = var.max_buffer_size
    flush_time                       = var.flush_time
    schema                           = var.target_schema
    table                            = var.target_table
    tasks                            = var.tasks_count
  }
}

resource "local_file" "json" {
  sensitive_content = data.template_file.snowflake_connector_config.rendered
  filename          = "${path.module}/snowflake-connector-config.json"
}

resource "null_resource" "upload_config" {
  triggers = {
    cluster_url    = var.kafka_connect_url
    connector_name = var.connector_name
  }

  provisioner "local-exec" {
    command = <<EOF
curl -X PUT -H "Accept:application/json" -H "Content-Type:application/json" \
  -d "@${local_file.json.filename}" \
  ${self.triggers.cluster_url}/connectors/${self.triggers.connector_name}/config
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
curl --output /dev/null --fail -X DELETE -H "Accept:application/json" -H "Content-Type:application/json" \
  ${self.triggers.cluster_url}/connectors/${self.triggers.connector_name}
# Try to wait until the resource is actually destroyed. This can cause problems when uploading a new config
# and terraform does a destroy then a create. This should probably be replaced with some kind of API polling.
sleep 2.0
EOF
  }
}
