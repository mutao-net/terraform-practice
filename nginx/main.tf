variable "instance_type" {}

resource "aws_instance" "default" {
  ami                    = "ami-0218d08a1f9dac831"
  vpc_security_group_ids = [aws_security_group.default.id]
  instance_type          = var.instance_type
  tags = {
    Name = "nginx_server"
  }

  user_data = <<EOF
    #!/bin/bash
    amazon-linux-extras install -y nginx1
    systemctl restart nginx.service
    EOF
}

resource "aws_security_group" "default" {
  name = "ec2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_dns" {
  value = aws_instance.default.public_dns
}
