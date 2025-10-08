# =============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.main.tf
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "iam_role" {
  source  = "terraform-aws-modules/iam/aws"
  version = "5.7.0"

  for_each = local.roles_with_defaults

  name = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_auth0.json
  attach_managed_policy_arns = each.value.managed_policy_arns
  tags = each.value.tags
}

# =============================================================================
