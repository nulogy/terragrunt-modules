resource "null_resource" "heartbeat_kafta_topic" {
  triggers = {
    kafka_bootstrap_servers = var.kafka_bootstrap_servers
    heartbeat_topic_name    = local.heartbeat_topic
  }

  provisioner "local-exec" {
    command = "echo noop"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo noop"
  }
}
