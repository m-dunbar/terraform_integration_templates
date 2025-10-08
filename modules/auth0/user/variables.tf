# =============================================================================
# terraform_integration_templates :: modules/auth0/user/variables.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "auth0_users" {
  description = "List of user objects to be created"
  type = list(object({
    username       = string
    given_name     = string
    family_name    = string
    nickname       = optional(string)
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

variable "connection_name" {
  description = "Name of the Auth0 connection (e.g., 'Username-Password-Authentication')"
  type        = string
  default     = "Username-Password-Authentication"
}

# =============================================================================
