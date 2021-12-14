resource "null_resource" "heartbeat_kafta_topic" {
  triggers = {
    kafka_bootstrap_brokers = var.kafka_bootstrap_brokers
    heartbeat_topic_name    = local.heartbeat_topic
  }

  provisioner "local-exec" {
    command = <<EOF
docker run --rm --entrypoint="" bitnami/kafka:2.5.0 kafka-topics.sh --create \
  --bootstrap-server ${self.triggers.kafka_bootstrap_brokers} --topic ${self.triggers.heartbeat_topic_name} \
  --replication-factor 3 --partitions 10 --config retention.ms=3600000 --config delete.retention.ms=0
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
docker run --rm --entrypoint="" bitnami/kafka:2.5.0 kafka-topics.sh --delete \
  --bootstrap-server ${self.triggers.kafka_bootstrap_brokers} --topic ${self.triggers.heartbeat_topic_name}
EOF
  }
}