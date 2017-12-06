output "kms_key_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_kms_key.kms_key.*.id, list("")), 0)}"
}
