output "runners_security_group_id" {
  value = "${module.runners_stack.security_group_id}"
}

output "runners_public_subnet_ids" {
  value = "${module.runners_stack.public_subnet_ids}"
}

output "runners_vpc_id" {
  value = "${module.runners_stack.vpc_id}"
}
