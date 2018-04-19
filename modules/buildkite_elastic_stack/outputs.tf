output "stack_managed_secrets_bucket" {
  value = "${aws_cloudformation_stack.stack.outputs["ManagedSecretsBucket"]}"
}
