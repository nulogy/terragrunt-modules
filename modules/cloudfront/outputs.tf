output "cloudfront_domain_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_cloudfront_distribution.cf_distribution.*.domain_name, list("")), 0)}"
}

output "hosted_zone_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_cloudfront_distribution.cf_distribution.*.hosted_zone_id, list("")), 0)}"
}