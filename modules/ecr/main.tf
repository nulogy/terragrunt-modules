resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count = var.enable_default_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.ecr_repo[0].name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only maintain the newest ${var.image_lifecycle_count} images",
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
