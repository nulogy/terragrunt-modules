resource "aws_ecr_repository" "ecr_repo" {
  count = length(var.skip) > 0 ? 0 : 1

  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count = length(var.skip) > 0 ? 0 : 1

  repository = aws_ecr_repository.ecr_repo[0].name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only maintain the newest 500 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": ${var.image_lifecycle_count}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

}

