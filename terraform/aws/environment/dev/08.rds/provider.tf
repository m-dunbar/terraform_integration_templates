# =============================================================================
# terraform_integration_templates :: environment/dev/08.rds/provider.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
  }
  required_version = ">= 1.13.3, < 2.0.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# ======================================================================
