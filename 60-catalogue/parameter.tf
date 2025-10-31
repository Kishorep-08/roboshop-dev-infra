resource "aws_ssm_parameter" "ami_uname" {
    name = "${var.ami_name}-username"
    type = "String"
    value = "ec2-user"
}

resource "aws_ssm_parameter" "ami_pwd" {
    name = "${var.ami_name}-password"
    type = "SecureString"
    value = "DevOps-321"
}
