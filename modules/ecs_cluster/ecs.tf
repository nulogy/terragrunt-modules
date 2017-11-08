resource "aws_ecs_cluster" "ecs_cluster" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.name}"
}
