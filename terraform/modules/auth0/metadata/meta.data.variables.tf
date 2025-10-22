# =============================================================================
# terraform_integration_templates :: terraform/modules/auth0/metadata/meta.data.variables.tf
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

# =============================================================================
