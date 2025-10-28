locals {
    common_name = "${var.project_name}-${var.environment}"
}

locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}