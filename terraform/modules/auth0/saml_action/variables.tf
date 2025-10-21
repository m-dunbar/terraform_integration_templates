# =============================================================================
# terraform_integration_templates :: modules/auth0/saml_action/variables.tf 
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "environment"{ 
  description = "The Auth0 environment to which we're adding the SAML action"
  type = string 
}

variable "auth0_role_to_aws_role_arn_map" {
  description = "One-to-one mapping of Auth0 groups to AWS IAM role ARN"
  type            = map(string)
}

# =============================================================================
