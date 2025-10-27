# =============================================================================
# terraform_integration_templates :: environment/dev/04.dynamodb/dynamodb.outputs.tf
#      :: mdunbar :: 2025 oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "terraform_kms_key" {
  value = local.terraform_kms_key_arn
}

# =============================================================================
