# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.account_alias.tf
#       :: mdunbar :: 2025 Oct 17 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# This resource sets a human-friendly AWS account alias (an account 'name' for easier identification.
resource "aws_iam_account_alias" "account_name" {
  account_alias = local.account_name
}

# =============================================================================
