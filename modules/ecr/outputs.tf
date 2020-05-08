output "ecr_url" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = element(
    concat(aws_ecr_repository.ecr_repo.*.repository_url, [""]),
    0,
  )
}

output "ecr_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = element(concat(aws_ecr_repository.ecr_repo.*.name, [""]), 0)
}

