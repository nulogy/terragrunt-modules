output "builder_stack_managed_secrets_bucket" {
  value = "${aws_cloudformation_stack.builders.outputs["ManagedSecretsBucket"]}"
}
output "runner_stack_managed_secrets_bucket" {
  value = "${aws_cloudformation_stack.runners.outputs["ManagedSecretsBucket"]}"
}
