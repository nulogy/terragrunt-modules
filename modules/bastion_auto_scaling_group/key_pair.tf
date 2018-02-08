resource "aws_key_pair" "bastion_key" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  key_name = "${var.environment_name}-bastion-key"
  public_key = "${var.public_key}"
}
