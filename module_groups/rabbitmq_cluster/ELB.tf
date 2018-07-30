module "amqp_load_balancer" {
  source = "/deployer/modules/amqp_load_balancer"

  certificate_domain = "${var.certificate_domain}"
  environment_name = "${var.environment_name}"
  public_subnet_ids = "${var.public_subnet_ids}"
  vpc_id = "${var.vpc_id}"
}
