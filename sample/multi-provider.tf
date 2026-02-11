terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "state-bucket"
    key            = "multi-provider/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

provider "google" {
  credentials = file("path/to/credentials.json")
  project     = "gcp-project"
  region      = "us-central1"
}

resource "aws_instance" "example" {
  provider      = aws.east
  ami           = "ami-1234"
  instance_type = "t2.micro"
}

resource "aws_instance" "west_example" {
  provider      = aws.west
  ami           = "ami-1234"
  instance_type = "t2.micro"
}

resource "google_compute_instance" "vm_instance" {
  name         = "google-vm"
  machine_type = "e2.medium"
  zone         = "us-entral1-a"
  project      = google
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
  }
}
