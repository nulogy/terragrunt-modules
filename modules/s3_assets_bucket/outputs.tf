output "assets_bucket" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_s3_bucket.static_assets.*.bucket, list("")), 0)}"
}

output "assets_bucket_domain" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_s3_bucket.static_assets.*.bucket_domain_name, list("")), 0)}"
}