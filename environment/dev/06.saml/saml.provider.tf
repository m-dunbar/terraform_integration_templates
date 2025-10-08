# ======================================================================
# terraform_integration_templates :: s3.provider.tf :: mdunbar :: 2025 oct 05
# ======================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
  required_version = ">= 1.13.3, < 2.0.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# ======================================================================
