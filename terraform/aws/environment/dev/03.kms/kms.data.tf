# =============================================================================
# terraform_integration_templates :: environment/dev/03.kms/kms.data.tf
#      :: mdunbar :: 2025 oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# =============================================================================
