data "aws_ami" "devops_ami" {
    most_recent = true
    owners = ["973714476881"]

    filter {
      name = "name"
      values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.environment}/catalogue_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}