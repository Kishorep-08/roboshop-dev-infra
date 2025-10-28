module "vpc" {
    source = "git::https://github.com/Kishorep-08/terraform-aws-vpc.git?ref=main"
    vpc_cidr_block = var.vpc_cidr_block
    project_name = var.project_name
    environment = var.environment
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
}

