# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/01.saml/saml.variables.tf
#       :: mdunbar :: 2025 Oct 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "auth0_domain" {
  description = "Auth0 domain for SAML integration"
  type        = string
}

variable "auth0_client_id" {
  description = "Auth0 client ID for SAML integration"
  type        = string
}

variable "auth0_client_secret" {
  description = "Auth0 client secret for SAML integration"
  type        = string
}

# =============================================================================
