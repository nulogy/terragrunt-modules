locals {
  replication_slot_name = (var.replication_slot_name_override == "") ? "${replace(var.connection_name, "-", "_")}_debezium_slot" : var.replication_slot_name_override
  heartbeat_topic       = "heartbeat-${var.connection_name}"
  heartbeat_query       = <<EOF
    SET search_path TO ${join(",", var.postgres_search_paths)};

    DELETE FROM public.${var.events_table}
    WHERE created_at < now() - INTERVAL '${var.subscription_events_ttl}';

    INSERT INTO public.${var.events_table}
      (id, subscription_id, partition_key, topic_name, company_uuid, event_json, created_at)
    VALUES (
      uuid_generate_v4(),
      '00000000-0000-0000-0000-000000000000',
      '00000000-0000-0000-0000-000000000000',
      '${local.heartbeat_topic}',
      '00000000-0000-0000-0000-000000000000',
      '{}',
      now()
    );
  EOF
  pg_docker_image       = var.postgres_version == "latest" ? "postgres:alpine" : "postgres:${var.postgres_version}-alpine"
}

data "template_file" "debezium_config" {
  template = file("${path.module}/debezium-config.tpl")

  vars = {
    bootstrap_servers  = var.kafka_bootstrap_servers
    connection_name    = var.connection_name
    database_address   = var.database_address
    database_name      = var.database_name
    database_password  = var.database_password
    database_user      = var.database_username
    events_table       = var.events_table
    heartbeat_query    = local.heartbeat_query
    initial_statements = local.heartbeat_query
    publication_name   = var.publication_name
    slot_name          = local.replication_slot_name
  }
}

// Writing to a local file avoids awkward escaping of single and double quotes when posting with curl
resource "local_file" "json" {
  sensitive_content = data.template_file.debezium_config.rendered
  filename          = "${path.module}/debezium-config.json"
}

resource "null_resource" "upload_config" {
  depends_on = [null_resource.heartbeat_kafta_topic, null_resource.postgres_publication]
  triggers = {
    cluster_url     = var.kafka_connect_url
    connection_name = var.connection_name
    config          = data.template_file.debezium_config.rendered
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
# Like most Kafka Connect API calls, this is done asynchronously and will be eventually consistent across the cluster.
# Sleep to give it some time to delete the connector, so that Terraform does not immediately try to do a create after a delete.
sleep 10.0
EOF
  }
}
