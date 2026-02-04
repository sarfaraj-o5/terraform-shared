terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }

  backend "s3" {
    bucket         = "remote-state"
    key            = "vpc-prod"
    region         = "us-east-1"
    dynamodb_table = "locking"
  }
}

provider "aws" {
  region = "us-east-1"
}
