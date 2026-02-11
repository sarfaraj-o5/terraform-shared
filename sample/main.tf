resource "aws_instance" "example" {
  ami           = local.ami_to_use
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = local.instance_name
  }
  ## Add a simple block for SG allowing  SSH access 
  vpc_security_group_ids = [aws_security_group.ssh.id]
}

## create a sg allowing SSH inbound traffic
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.default.id

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

## a default VPC to attach instance
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "default_vpc"
  }
}
