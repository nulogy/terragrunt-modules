locals {
  heartbeat_topic_name = "heartbeat-${var.environment_name}"
  debezium_user_name   = "debezium"
}

resource "null_resource" "create_topic" {
  triggers = {
    debezium_config__bootstrap_servers = var.debezium_config__bootstrap_servers
    heartbeat_topic_name = local.heartbeat_topic_name
  }
  provisioner "local-exec" {
    command = <<EOF
docker run --rm --entrypoint="" bitnami/kafka:2.5.0 kafka-topics.sh --create \
  --bootstrap-server ${self.triggers.debezium_config__bootstrap_servers} --topic ${self.triggers.heartbeat_topic_name} \
  --replication-factor 3 --partitions 10 --config retention.ms=3600000 --config delete.retention.ms=0
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
docker run --rm --entrypoint="" bitnami/kafka:2.5.0 kafka-topics.sh --delete \
  --bootstrap-server ${self.triggers.debezium_config__bootstrap_servers} --topic ${self.triggers.heartbeat_topic_name}
EOF
  }
}

resource "null_resource" "upload_config" {
  depends_on = [null_resource.create_topic, null_resource.create_debezium_user]
  triggers   = {
    cluster_url = var.debezium_config__cluster_url
    environment_name = var.environment_name
  }

  provisioner "local-exec" {
    command = <<EOF
curl -X PUT -H "Accept:application/json" -H "Content-Type:application/json" \
  -d "@${local_file.json.filename}" \
  ${self.triggers.cluster_url}/connectors/${self.triggers.environment_name}/config
EOF
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = <<EOF
curl --output /dev/null --fail -X DELETE -H "Accept:application/json" -H "Content-Type:application/json" \
  ${self.triggers.cluster_url}/connectors/${self.triggers.environment_name}
# Try to wait until the resource is actually destroyed. This can cause problems when uploading a new config
# and terraform does a destroy then a create. This should probably be replaced with some kind of API polling.
sleep 2.0
EOF
  }
}

resource "local_file" "json" {
  sensitive_content = data.template_file.debezium_config.rendered
  filename          = "${path.module}/debezium-db-config.json"
}

data "template_file" "debezium_config" {
  template = file("${path.module}/debezium-db-config.tpl")

  vars = {
    bootstrap_servers    = var.debezium_config__bootstrap_servers
    database_address     = var.database_address
    database_name        = var.database_name
    database_password    = data.aws_ssm_parameter.debezium_db_password.value
    database_user        = local.debezium_user_name
    environment_name     = var.environment_name
    events_table         = var.debezium_config__events_table
    heartbeat_topic_name = local.heartbeat_topic_name
    slot_name            = "${replace(var.environment_name, "-", "_")}_debezium_slot"
  }
}