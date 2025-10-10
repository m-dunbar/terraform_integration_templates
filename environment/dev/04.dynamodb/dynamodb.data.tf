# =============================================================================
# terraform_integration_templates :: environment/dev/04.dynamodb/dynamodb.data.tf
#      :: mdunbar :: 2025 oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "aws_kms_alias" "terraform" {
  name = "alias/terraform"
}

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "terraform_kms_key" {
  value = data.aws_kms_alias.terraform.arn
}

# =============================================================================
