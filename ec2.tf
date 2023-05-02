## Security group
locals {
  az_1a            = var.availability_zone_1a
  public_subnet_1a = var.public_subnet_1a
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
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = local.az_1a
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  subnet_id                   = var.public_subnet_1a
  security_groups             = flatten([var.security_groups_ids])
  user_data                   = file("files/server_config.sh")
  tenancy                     = "default"

  tags = {
    Name = var.instance_name
  }
}

