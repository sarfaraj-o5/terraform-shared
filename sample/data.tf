data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.0-amd-server-*"]
  }

  filter {
    name   = "virtualization"
    values = ["hvm"]
  }

  owners = ["099720109477"] ## cononical
}
