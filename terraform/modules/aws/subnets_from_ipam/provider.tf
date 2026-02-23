# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/subnets_from_ipam/provider.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# =============================================================================
