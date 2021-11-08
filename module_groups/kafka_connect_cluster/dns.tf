resource "aws_route53_record" "kafka_connect" {
  name    = local.normalized_cluster_name
  records = [module.kafka_connect.dns_name]
  ttl     = 60
  type    = "CNAME"
  zone_id = var.environment_dns_zone_id
}
