# =============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.locals.tf
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  account_id = data.aws_caller_identity.current.account_id

  assume_role_statement = [
    {
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${local.account_id}:role/auth0_saml_provider"]
        }
      ]
    }
  ]

  # Ensure all roles have default policy and merged tags
  roles_with_defaults = {
    for name, cfg in var.roles :
    name => {
      managed_policy_arns = length(cfg.managed_policy_arns) > 0 ? cfg.managed_policy_arns : ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      tags = merge(
        { Environment = var.environment, Project = "my-terraform-project" },
        cfg.tags
      )
    }
  }
}

# =============================================================================
