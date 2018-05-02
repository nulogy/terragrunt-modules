output "security_group_id" {
  value = "${aws_security_group.stack_security_group.id}"
}

output "public_subnet_ids" {
  value = "${module.public_subnets.public_subnet_ids}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
