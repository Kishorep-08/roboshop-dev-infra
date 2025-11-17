resource "aws_ssm_parameter" "listener_arn" {
    name = "/${var.project_name}/${var.environment}/backend_listener_arn"
    type = "String"
    value = "${aws_lb_listener.backend.arn}"
}