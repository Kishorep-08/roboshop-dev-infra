variable "project_name" {
    type = string
    default = "roboshop"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "sg_description" {
    type = string
    default = "Security group for mongodb server with egress rules"
}

variable "sg_names" {
    type = list
    default = [
        # Database SGs
        "mongodb", "redis", "mysql", "rabbitmq",
        # Backend SGs
        "catalogue", "user", "cart", "shipping", "payment",
        # Frontend SGs
        "frontend",   
        # Bastion SG
        "bastion",
        # Frontend Load balancer SG
        "frontend_alb" , 
        # Backend Load balancer SG
        "backend_alb"  
    ]
}
