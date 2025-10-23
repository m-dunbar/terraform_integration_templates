# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.data.tf
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "aws_iam_saml_provider" "auth0_saml" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/auth0-saml-provider"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# =============================================================================
