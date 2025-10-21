# =============================================================================
# terraform_integration_templates :: environment/dev/03.kms/kms.key.tf
#       :: mdunbar :: 2025 Oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description             = "Terraform KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  # Policy
  enable_default_policy = true
  key_owners            = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.environment}-Administrator"]
  key_users = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-provisioner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.environment}-Administrator"
  ]
  key_service_users     = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dynamodb-role",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/s3-role"
  ]

  # Aliases
  computed_aliases = {
    alias = { 
      name = "terraform"
    }
  }

  tags = {
    Environment = var.environment
    Managed_by  = "Terraform"
  }
}
# =============================================================================
