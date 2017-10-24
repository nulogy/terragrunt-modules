resource "aws_alb" "public_load_balancer" {
  name_prefix = "goPLB-"
  internal = false
  security_groups = ["${aws_security_group.ecs_lb_security_group.id}"]
  subnets = ["${aws_subnet.ecs_public_subnet_1.id}", "${aws_subnet.ecs_public_subnet_2.id}"]

  tags {
    Name = "Go public load balancer"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_alb_target_group" "target_group" {
  name_prefix = "goPtg-"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "Go public load balancer target group"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_alb_listener" "public_lb_listener" {
  load_balancer_arn = "${aws_alb.public_load_balancer.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${var.region_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    type = "forward"
  }
}
