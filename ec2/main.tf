locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
apt-get update && sudo apt-get install -y docker.io
apt-get install -y openjdk-8-jdk
EOF
}

resource "aws_instance" "ec2-tf-instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.tf-sg-1.id]
  associate_public_ip_address = true
  key_name                    = var.aws_key_pair_name
  user_data_base64            = base64encode(local.user_data)

  tags = {
    Name = "CreatedByTerraForm"
  }
}