locals {
    ami_id = data.aws_ami.devops_ami.id
}

locals {
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
}

locals {
    common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = true
    }
    common_name = "${var.project_name}-${var.environment}"
    database_subnet_ids = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
}