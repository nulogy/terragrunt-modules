output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}

output "assets_bucket" {
  value = module.s3_assets_bucket.assets_bucket
}

output "assets_bucket_domain" {
  value = module.s3_assets_bucket.assets_bucket_domain
}

output "domain_name" {
  value = module.route53_for_cloudfront.domain_name
}

