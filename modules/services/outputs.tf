output "assets_bucket" {
  value = "${aws_s3_bucket.static_assets.bucket}"
}

output "assets_bucket_domain" {
  value = "${aws_s3_bucket.static_assets.bucket_domain_name}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.target_group.arn}"
}

output "ecs_cloudwatch_log_group_name" {
  value = "${aws_cloudwatch_log_group.log_group.name}"
}

output "public_load_balancer_fqdn" {
  value = "${aws_route53_record.plb_route53_record.fqdn}"
}
