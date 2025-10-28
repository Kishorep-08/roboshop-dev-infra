variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "public_subnet_cidrs" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
    type = list
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
    type = list
    default = ["10.0.21.0/24", "10.0.22.0/24"]
}