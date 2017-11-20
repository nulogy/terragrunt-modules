output "domain_name" {
  value = "${aws_route53_record.plb_route53_record.fqdn}"
}
