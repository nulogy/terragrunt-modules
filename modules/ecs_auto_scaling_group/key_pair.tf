resource "aws_key_pair" "ecs_key" {
  key_name = "${var.environment_name}-ecs-key"
  public_key = "${var.public_key}"
}
