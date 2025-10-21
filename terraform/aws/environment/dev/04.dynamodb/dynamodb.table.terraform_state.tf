# =============================================================================
# terraform_integration_templates :: environment/dev/04.dynamodb/dynamodb.table.terraform_state.tf
#       :: mdunbar :: 2025 Oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name           = "terraform_locks"
  hash_key       = "LockID"
  
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  deletion_protection_enabled = true
  point_in_time_recovery_enabled = false

  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = ( var.bootstrap_plan
    ? null
    : local.terraform_kms_key_arn
  )

  ttl_enabled        = false

  tags = {
    Name       = "Terraform lock table"
    Environment = var.environment
    Managed_by  = "Terraform"
  }
}

# =============================================================================
