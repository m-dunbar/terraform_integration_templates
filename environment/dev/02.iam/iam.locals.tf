# =============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.locals.tf
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  account_id = data.aws_caller_identity.current.account_id
  saml_provider_id = [ "arn:aws:iam::${local.account_id}:saml-provider/auth0_saml_provider" ]

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
}

# =============================================================================
