resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id = local.private_subnet_ids
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-catalogue"
    }
  )

}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  connection {
    type = "ssh"
    user = "${aws_ssm_parameter.ami_uname.value}"
    password = "${aws_ssm_parameter.ami_pwd.value}"
    host = "${aws_instance.catalogue.private_ip}"
  }

  provisioner "file" {
    source = "catalogue.sh" # Local file path
    destination = "/tmp/catalogue.sh" # Destination on catalogue EC2
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!",
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

# Stopping catalogue instance to take AMI
resource "aws_ec2_instance_state" "catalogue" {
instance_id = "${aws_instance.catalogue.id}" 
state       = "stopped"
depends_on = [terraform_data.catalogue]  
}           

# To take AMI from catalogue instance
resource "aws_ami_from_instance" "catalogue-ami" {
  name               = "${local.common_name}" # roboshop-dev-catalogue-ami
  source_instance_id = "${aws_instance.catalogue.id}"
  depends_on = [aws_ec2_instance_state.catalogue]
}
