resource "random_string" "secret" {
  length = 16
  special = false
}

// For serious environments, change the secrets after they are initially pregenerated.
resource "aws_ssm_parameter" "secret" {
  name = "/${var.environment_name}/rabbitmq/rabbitmq-erlang-cookie"
  type = "SecureString"
  key_id = "${var.kms_key_id}"
  value = "${random_string.secret.result}"

  lifecycle {
    ignore_changes = [ "value" ]
  }
}
