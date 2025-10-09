# =============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.main.tf
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "iam_role_saml" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  for_each = local.iam_role_list

  name              = each.key
  enable_saml       = true
  saml_provider_ids = each.value.saml_provider_ids
  policies          = each.value.policies

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# =============================================================================
