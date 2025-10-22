# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.main.tf
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "iam_role_saml" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  for_each = { for role in var.iam_role_list : role.role_name => role }

  name              = each.key
  use_name_prefix   = false
  enable_saml       = true
  saml_provider_ids = local.saml_provider_id
  policies          = each.value.policies

  tags = {
    Environment = var.environment
    Managed_by  = "Terraform"
  }
}

# =============================================================================
