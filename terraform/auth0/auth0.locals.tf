# =============================================================================
# terraform_integration_templates :: auth0/auth0.locals.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
locals {
  # NOTE: you can hardcode your AWS Account ID, but using a dynamic lookup is 
  # recommended best practice.

  # However, when using a dynamic lookup, if you have multiple AWS accounts,
  # be VERY careful which AWS account profile you have actively configured
  # PRIOR to running terraform commands in this module
  saml_provider_name = "auth0-saml-provider"
  environment        = "dev"

  # hardcoded examples:
  # aws_account_id     = "123456789012"   # Replace with your actual AWS Account ID
  # aws_account_id     = "000000000000"   # localstack account id

  # dynamic lookup approach:
  aws_account_id     = data.aws_caller_identity.current.account_id  # lookup your current AWS Account ID

  auth0_role_to_aws_role_arn_map = {
    for mapping in var.auth0_role_to_aws_role_map :
    mapping.auth0_role => "arn:aws:iam::${local.aws_account_id}:role/${mapping.aws_role_name},arn:aws:iam::${local.aws_account_id}:saml-provider/${local.saml_provider_name}"
  }
}

# =============================================================================
