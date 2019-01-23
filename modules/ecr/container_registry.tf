resource "aws_ecr_repository" "ecr_repo" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.name}"
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = "${aws_ecr_repository.ecr_repo.name}"

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only maintain the newest 500 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 500
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
