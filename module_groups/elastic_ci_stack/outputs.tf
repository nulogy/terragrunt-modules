output "builder_stack_managed_secrets_bucket" {
  value = "${module.builders_stack.stack_managed_secrets_bucket}"
}

output "runner_stack_managed_secrets_bucket" {
  value = "${module.runners_stack.stack_managed_secrets_bucket}"
}
