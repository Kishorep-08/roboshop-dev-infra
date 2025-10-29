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

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project_name}/${var.environment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/database_subnet_ids"
}