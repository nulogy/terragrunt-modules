module "s3_redirect_bucket" {
  source = "../../modules/s3_redirect_bucket"

  environment_name        = var.environment_name
  destination_domain_name = var.destination_domain_name
}

module "cf_redirect_distribution" {
  source = "../../modules/cloudfront_s3_origin"

  environment_name               = var.environment_name
  source_cloudfront_cert_domain  = var.source_cloudfront_cert_domain
  source_domain_name             = var.source_domain_name
  s3_bucket_regional_domain_name = module.s3_redirect_bucket.bucket_regional_domain_name
  s3_website_endpoint            = module.s3_redirect_bucket.website_endpoint
}

module "route53_redirect" {
  source = "../../modules/route53_alias_record"

  target_domain  = module.cf_redirect_distribution.domain_name
  target_zone_id = module.cf_redirect_distribution.hosted_zone_id
  domain         = var.source_domain
  subdomain      = var.source_subdomain
}
