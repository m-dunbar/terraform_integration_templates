# =============================================================================
# terraform_integration_templates :: environment/dev/05.s3/s3.data.tf
#      :: mdunbar :: 2025 oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "aws_kms_key" "terraform" {
  key_id = "alias/terraform"
}

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "terraform_kms_key" {
  value = data.aws_kms_key.terraform.arn
}

# =============================================================================
