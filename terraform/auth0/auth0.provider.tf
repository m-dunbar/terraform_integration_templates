# =============================================================================
# terraform_integration_templates :: auth0/auth0.provider.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = ">= 1.31.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
  }
  required_version = ">= 1.13.3, < 2.0.0"
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_saml_client_id
  client_secret = var.auth0_saml_client_secret
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# =============================================================================
