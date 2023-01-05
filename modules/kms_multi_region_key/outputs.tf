output "kms_key_arn" {
  value = aws_kms_key.primary.arn
}

output "kms_key_replica_arn" {
  value = aws_kms_replica_key.replica.arn
}