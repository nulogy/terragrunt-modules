output "security_group_id" {
  value = aws_security_group.stack_security_group.id
}

output "instance_role_name" {
  value = aws_cloudformation_stack.stack.outputs["InstanceRoleName"]
}
