resource "null_resource" "create_topic" {
  for_each = var.topics

  provisioner "local-exec" {
    command = <<EOF
docker run --rm --entrypoint="" bitnami/kafka:2.5.0 kafka-topics.sh --create \
  --bootstrap-server ${var.bootstrap_servers} \
  --topic ${each.key} \
  --replication-factor ${var.replication_factor} \
  --partitions ${var.partitions} \
  --config retention.ms=${var.retention} \
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
docker run --rm --entrypoint="" bitnami/kafka:2.5.0 kafka-topics.sh --delete \
  --bootstrap-server ${var.bootstrap_servers} \
  --topic ${each.key}
EOF
  }
}
