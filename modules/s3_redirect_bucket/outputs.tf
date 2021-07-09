output "bucket_regional_domain_name" {
  value = aws_s3_bucket.redirect_bucket.bucket_regional_domain_name
}

output "website_endpoint" {
  value = aws_s3_bucket.redirect_bucket.website_endpoint
}
