## Security group
locals {
  az_1a            = var.availability_zone_1a
  public_subnet_1a = var.public_subnet_1a
  ingress_rules = [
    {
      port        = 22
      description = "Ingress rule for port 22"
    },
    {
      port        = 80
      description = "Ingress rule for port 80"
    },
    {
      port        = 8080
      description = "Ingress rule for port 8080"
    }
  ]
}
data "external" "whatismyip" {
  program = ["/bin/bash", "${path.module}/files/whatismyip.sh"]
}

resource "aws_security_group" "allow_ssh" {
  name        = "devsecops-cicd-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-public-sg"
  }
}

# This function will get the latest ami id from AMI list
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20*"]
  }
}

# This block will create the aws ec2 instance
resource "aws_instance" "devsecops-public-ec2" {
  ami               = data.aws_ami.ubuntu.id
  availability_zone = local.az_1a
  instance_type     = var.instance_type
  #iam_instance_profile        = aws_iam_instance_profile.iam_profile.name
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  subnet_id                   = var.public_subnet_1a
  security_groups             = [aws_security_group.allow_ssh.id]
  user_data                   = file("files/server_config.sh")
  tenancy                     = "default"

  tags = {
    Name = var.instance_name
  }

  depends_on = [
    aws_security_group.allow_ssh
  ]
}

