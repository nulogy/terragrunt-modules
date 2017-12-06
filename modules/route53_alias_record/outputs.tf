output "domain_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_route53_record.route53_record.*.fqdn, list("")), 0)}"
}
