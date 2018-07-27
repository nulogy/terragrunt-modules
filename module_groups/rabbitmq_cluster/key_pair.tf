resource "aws_key_pair" "key_pair" {
  key_name = "${var.environment_name}-rabbitmq"
  public_key = "${var.public_key}"
}
