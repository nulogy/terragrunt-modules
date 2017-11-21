output "domain_name" {
  value = "${aws_route53_record.route53_record.fqdn}"
}
