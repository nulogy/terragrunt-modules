output "assets_bucket" {
  value = "${aws_s3_bucket.static_assets.bucket}"
}

output "assets_bucket_domain" {
  value = "${aws_s3_bucket.static_assets.bucket_domain_name}"
}