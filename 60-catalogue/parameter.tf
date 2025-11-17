resource "aws_ssm_parameter" "ami_uname" {
    name = "${var.ami_name}-username"
    type = "String"
    value = "ec2-user"
}

resource "aws_ssm_parameter" "ami_pwd" {
    name = "${var.ami_name}-password"
    type = "SecureString"
    value = "DevOps321"
}

resource "aws_ssm_parameter" "catalogue_tg" {
    name = "/${var.project_name}/${var.environment}/catalogue_tg"
    type = "String"
    value = "${aws_lb_target_group.catalogue.arn}"
}
