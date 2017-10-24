resource "aws_ecr_repository" "go_ecr_repo" {
  name = "${var.environment_name}"
}
