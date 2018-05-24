module "s3_assets_bucket" {
  source = "../../modules/s3_assets_bucket"
  skip = "${var.skip}"

  environment_name = "${var.environment_name}"
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  skip = "${var.skip}"

  app_fqdn = "${var.app_fqdn}"
  aws_profile = "${var.aws_profile}"
  assets_bucket_domain = "${module.s3_assets_bucket.assets_bucket_domain}"
  cert_domain = "${var.cert_domain}"
  environment_name = "${var.environment_name}"
  route53_domain = "${var.route53_domain}"
  route53_subdomain = "${var.route53_subdomain}"
  static_assets_path = "${var.static_assets_path}"
}

module "route53_for_cloudfront" {
  source = "../../modules/route53_alias_record"
  skip = "${var.skip}"

  domain = "${var.route53_domain}"
  subdomain = "${var.route53_subdomain}"
  target_domain = "${module.cloudfront.cloudfront_domain_name}"
  target_zone_id = "${module.cloudfront.hosted_zone_id}"
}
