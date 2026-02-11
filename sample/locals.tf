locals {
  instance_name = "MyTerraformInstance"
  ami_to_use    = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
}
