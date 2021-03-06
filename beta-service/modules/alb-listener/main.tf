resource "aws_alb_target_group" "beta_service_tg" {
  name = "${replace(var.service_name, "/(.{0,28})(.*)/", "$1")}-tg"

  protocol = "HTTP"
  port = "${var.container_port}"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/ping"
  }
}

resource "aws_alb_listener_rule" "beta_service_listener" {
  listener_arn = "${var.alb_listener_arn}"
  priority = 200

  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.beta_service_tg.arn}"
  }

  condition {
    field = "path-pattern"
    values = ["/beta/*"]
  }

  depends_on = ["aws_alb_target_group.beta_service_tg"]
}
