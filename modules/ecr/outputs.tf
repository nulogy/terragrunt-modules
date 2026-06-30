output "ecr_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_name" {
  value = aws_ecr_repository.ecr_repo.name
}
