module "s3_assets_bucket" {
  source = "../../modules/s3_assets_bucket"
  environment_name = "${var.environment_name}"
  skip = "${var.skip}"
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  app_fqdn = "${var.app_fqdn}"
  assets_bucket_domain = "${module.s3_assets_bucket.assets_bucket_domain}"
  cert_domain = "${var.cert_domain}"
  environment_name = "${var.environment_name}"
  route53_domain = "${var.route53_domain}"
  route53_subdomain = "${var.route53_subdomain}"
  skip = "${var.skip}"
  static_assets_path = "${var.static_assets_path}"
}

module "route53_for_cloudfront" {
  source = "../../modules/route53_alias_record"

  domain = "${var.route53_domain}"
  skip = "${(length(var.skip_route53) == 0 && length(var.skip) == 0) ? 1 : 0}"
  subdomain = "${var.route53_subdomain}"
  target_domain = "${module.cloudfront.cloudfront_domain_name}"
  target_zone_id = "${module.cloudfront.hosted_zone_id}"
}