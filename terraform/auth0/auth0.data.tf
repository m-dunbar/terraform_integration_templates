# =============================================================================
# terraform_integration_templates :: auth0/auth0.data.tf
#       :: mdunbar :: 2025 Oct 13 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}


# =============================================================================
