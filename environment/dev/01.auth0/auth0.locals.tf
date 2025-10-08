# =============================================================================
# terraform_integration_templates :: environment/dev/auth0/auth0.locals.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
locals {
  # aws_account_id     = "123456789012"  # Replace with your actual AWS Account ID
  aws_account_id     = "000000000000"    # localstack account id
  saml_provider_name = "auth0-saml-provider"
  environment        = "dev"

  auth0_group_to_aws_role_arn_map = {
    for mapping in var.auth0_group_to_aws_role_map :
    mapping.auth0_group => "arn:aws:iam::${local.aws_account_id}:role/${local.environment}-${mapping.aws_role_name},arn:aws:iam::${local.aws_account_id}:saml-provider/${local.saml_provider_name}"
  }
}

# =============================================================================
