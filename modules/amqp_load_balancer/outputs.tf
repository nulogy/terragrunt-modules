output "aws_security_group_rabbitmq_elb_id" {
  value = aws_security_group.rabbitmq_elb.id
}

output "aws_elb_name" {
  value = aws_elb.elb.name
}

output "aws_elb_dns_name" {
  value = aws_elb.elb.dns_name
}

output "aws_elb_zone_id" {
  value = aws_elb.elb.zone_id
}

