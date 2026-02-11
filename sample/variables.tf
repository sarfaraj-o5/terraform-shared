variable "instance_type" {
  description = "The type of EC2 instance"
  default     = "t3.medium"
}

variable "ami_id" {
  description = "The Amazon Machine Image(AMI) ID to use for the instance"
  type        = string
  default     = "ami-1234"
}

variable "key_name" {
  description = "The name of SSH Key to access the EC2 instance"
  type        = string
}
