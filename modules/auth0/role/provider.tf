# =============================================================================
# terraform_integration_templates :: modules/auth0/role/provider.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = ">= 1.31.0"
    }
  }
  required_version = ">= 1.13.3, < 2.0.0"
}

# provider "auth0" {
#   source = "auth0/auth0"
# }

# =============================================================================
