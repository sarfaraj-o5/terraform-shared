## remote state backend

backend "s3" {
  bucket         = "-timing-backend-s3"
  key            = "provisioner"
  region         = "us-east-1"
  dynamodb_table = "timing-lock"
}

## variables

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "Provide the VPC CIDR"
}

## refer var.var-name

module "vpc" {
  source             = "git::https://github.com//vpc"
  vpc_cidr           = var.vpc_cidr
  tags               = var.tags
  public_subnet_cidr = var.public_subnet_cidr
}

## vars

variable "tags" {
  type = map(any)
  default = {
    Name        = "timing"
    Environment = "DEV"
    Terraform   = "true"
  }
}

### terraform apply -var-file=dev.tfvars

## count and count index

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr) ## count = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    var.tags,
    var.public_subnet_tags,
    { "Name" = var.public_subnet_names[count.index] } ## this is the unique name for each subnet
  )
}

variable "azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

## Outpus

## vpc_id = module.vpc.vpc_id

output "vpc_id" {
  value = aws_vpc.main.id
}

## data sources

data "aws_ssm_parameter" "app_alb_security_group_id" {
  name = "/timing/vpc/app_alb_security_group_id"
}

locals {
  tags = {
    Name        = "timing-web-frontend"
    Environment = "DEV"
    Terraform   = "true"
  }
}

locals {
  az_count  = 2
  azs       = slice(data.aws_availability_zones.azs_info.names, 0, local.az_count)
  az_labels = [element(split("-", local.azs[0], length(split("-", local.azs[0])) - 1), element(split("-", local.azs[1], length(split("-", local.azs[1])) - 1)))]
}

## app_alb_security_group_id = data.aws_ssm_parameter.app_alb_security_group_id.value
## vpc_id = data.aws_ssm_parameter.vpc_id.value
## web_alb_security_group_id = data.aws_ssm_parameter.app_web_security_group_id.value

data "aws_secretsmanager_secret" "rds_secret" {
  arn = var.rds_secret_arn
}

## workspace
resource "aws_instance" "example" {
  instance_type = var.instance_type
  tags = {
    Name = "app-${terraform.workspace}"
  }
}

