locals {
    ami_id = data.aws_ami.devops_ami.id
}

locals {
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
}

locals {
    private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
    vpc_zone_identifier = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
}

locals {
    common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = true
    }
    common_name = "${var.project_name}-${var.environment}"
}

locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}