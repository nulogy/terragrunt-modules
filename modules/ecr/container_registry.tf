resource "aws_ecr_repository" "ecr_repo" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.name}"
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = "${aws_ecr_repository.ecr_repo.name}"
  count = "${length(var.count_cap_tag_prefix) > 0 ? 1 : 0}"

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only maintain the newest 100 images",
      "selection": {
        "tagStatus": "tagged",
        "countType": "imageCountMoreThan",
        "tagPrefixList": [
          "${var.count_cap_tag_prefix}"
        ],
        "countNumber": 100
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
