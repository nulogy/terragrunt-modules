resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.name}"
}
