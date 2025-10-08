# =============================================================================
# terraform_integration_templates :: environment/dev/auth0/auth0.role_mapping.tf 
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "auth0_saml_action" {
  source      = "../../../modules/auth0/saml_action"
  environment = local.environment
  auth0_role_to_aws_role_arn_map = local.auth0_role_to_aws_role_arn_map
}

# =============================================================================
