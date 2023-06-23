terraform {
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "shashi-terraform"

  #   workspaces {
  #     name = "terraform-bootcamps"
  #   }
  # }
  # cloud {
  #   organization = "shashi-terraform"

  #   workspaces {
  #     name = "terraform-bootcamps"
  #   }
  # }

  # backend "s3" {
  #   bucket = "terraform-state-shashi21763453714"
  #   key    = "terraform/statefile"
  #   region = "us-east-1"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}