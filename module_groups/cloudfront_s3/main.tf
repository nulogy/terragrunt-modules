module "s3_assets_bucket" {
  source = "../../modules/s3_assets_bucket"
  environment_name = "${var.environment_name}"
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  app_fqdn = "${var.app_fqdn}"
  assets_bucket_domain = "${module.s3_assets_bucket.assets_bucket_domain}"
  cf_cert_arn = "${var.acm_cf_cert_arn}"
  environment_name = "${var.environment_name}"
  route_53_domain = "${var.route_53_domain}"
  route_53_subdomain = "${var.route_53_subdomain}"
  static_assets_path = "${var.static_assets_path}"
}
