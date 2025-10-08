# =============================================================================
# terraform_integration_templates :: environment/dev/auth0/auth0.variables.tf
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# Auth0 tenant domain (e.g., "mytenant.auth0.com")
variable "auth0_domain" {
  description = "Your Auth0 tenant domain"
  type        = string
}

# Auth0 Management API client ID (for Terraform provider)
variable "auth0_client_id" {
  description = "Auth0 Management API client ID"
  type        = string
}

# Auth0 Management API client secret (for Terraform provider)
variable "auth0_client_secret" {
  description = "Auth0 Management API client secret"
  type        = string
  sensitive   = true
}

variable "auth0_role_to_aws_role_map" {
  description = "Mapping of Auth0 groups to AWS IAM role + SAML provider pairs"
  type            = list(object({
    auth0_role   = string
    aws_role_name = string
  }))
}

variable "auth0_role_list" {
  description = "List of roles to be created in Auth0"
  type = list(object({
    role_name        = string
    role_description = optional(string)
  }))
}

variable "auth0_users" {
  description = "List of user objects to be created"
  type = list(object({
    username       = string
    given_name     = string
    nickname       = optional(string)
    family_name    = string
    name           = optional(string)
    password       = optional(string)
    email          = string
    email_verified = optional(bool)
    phone_number   = optional(string)
    phone_verified = optional(bool)
    group_ids      = optional(list(string))
    verify_email   = optional(bool)
    blocked        = optional(bool)
  }))
  default = []
}

variable "auth0_user_group_memberships" {
  description = "Mapping of Auth0 user emails to lists of Auth0 group names for group memberships"
  type        = map(list(string))
  default     = {}
}

# =============================================================================
