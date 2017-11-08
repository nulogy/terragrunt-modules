resource "aws_ecr_repository" "ecr_repo" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.name}"
}
