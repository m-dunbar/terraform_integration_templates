# =============================================================================
# terraform_integration_templates :: environment/dev/04.dynamodb/dynamodb.locals.tf
#       :: mdunbar :: 2025 Oct 12 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  kms_key_arn = try(data.aws_kms_key.terraform[0].arn, "KMS key not found")
}

# =============================================================================
