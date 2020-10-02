locals {
  default_heartbeat_query = <<EOF
      SET search_path TO public;

      DELETE FROM public.${events_table}
      WHERE created_at < now() - INTERVAL '3 days';

      INSERT INTO public.${events_table}
        (id, public_subscription_id, partition_key, topic_name, tenant_id, event_json, created_at)
      VALUES (
        uuid_generate_v4(),
        '00000000-0000-0000-0000-000000000000',
        '00000000-0000-0000-0000-000000000000',
        '${heartbeat_topic_name}',
        '00000000-0000-0000-0000-000000000000',
        '{}',
        now()
      );
    EOF
  heartbeat_query         = (var.heartbeat_query == "use default") ? local.default_heartbeat_query : var.heartbeat_query
  heartbeat_topic_name    = "heartbeat-${var.environment_name}"
}

data "template_file" "debezium_config" {
  template = file("${path.module}/debezium-db-config.tpl")

  vars = {
    bootstrap_servers = var.debezium_config__bootstrap_servers
    database_address  = var.database_address
    database_name     = var.database_name
    database_password = var.database_password
    database_user     = var.database_username
    environment_name  = var.environment_name
    events_table      = var.debezium_config__events_table
    heartbeat_query   = local.heartbeat_query
    slot_name         = "${replace(var.environment_name, "-", "_")}_debezium_slot"
  }
}

resource "local_file" "json" {
  sensitive_content = data.template_file.debezium_config.rendered
  filename          = "${path.module}/debezium-db-config.json"
}

resource "null_resource" "upload_config" {
  depends_on = [null_resource.create_topic]
  triggers   = {
    cluster_url      = var.debezium_config__cluster_url
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
