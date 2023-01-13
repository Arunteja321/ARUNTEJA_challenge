terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
        
        ami = "ami-0b5eea76982371e91"
        subnet_id = "subnet-7086065e"
        instance_type = "t2.micro"
        key_name = "nginx-keypair"
        user_data = "${file("test-script.sh")}"

tags = {
                        Name = "nginx-web-server"
        }
}

resource "aws_security_group" "nginx_sg" {


ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    type = "terraform-test-security-group"
  }

  
}

resource "aws_network_interface_sg_attachment" "nginx_sg_attachment" {
  security_group_id    = aws_security_group.nginx_sg.id
  network_interface_id = aws_instance.ec2_instance.primary_network_interface_id
}

#resource "null_resource" "copy-test-file" {
#
#  connection {
#    type        = "ssh"
#    user        = "ec2-user"
#    private_key = "${file("nginx-keypair.pem")}"
#    host        = "${aws_instance.ec2_instance.public_dns}"
#  }
#
#  provisioner "file" {
#    source      = "nginx.conf"
#    destination = "/tmp/nginx.conf"
#  }
#
#  provisioner "remote-exec" {
#      inline = [
#        "sudo chmod 777 /etc/nginx/",
#        "sudo cp -rf /tmp/nginx.conf /etc/nginx",
#        "sudo systemctl restart nginx",
#    ]
#  }
#
#}