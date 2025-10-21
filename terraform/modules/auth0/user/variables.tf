# =============================================================================
# terraform_integration_templates :: modules/auth0/user/variables.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "connection_name" {
  description = "Name of the Auth0 connection (e.g., 'Username-Password-Authentication')"
  type        = string
  default     = "Username-Password-Authentication"
}

variable "auth0_role_list" {
  description = "List of roles to be created in Auth0"
  type = list(object({
    role_name        = string
    role_description = optional(string)
  }))
}

variable "auth0_role_objects" {
  description = "Map of Auth0 role_name => auth0_role object (from modules/auth0/role)"
  type        = map(object({
    id          = string
    name        = string
    description = string
    # any other attributes Auth0 provides
  }))
}

variable "auth0_users" {
  description = "List of user objects to be created"
  type = list(object({
    username       = string
    given_name     = string
    family_name    = string
    nickname       = optional(string)
    email          = string
    phone_number   = optional(string)
    phone_verified = optional(bool)
    group_ids      = optional(list(string))
    verify_email   = optional(bool)
    blocked        = optional(bool)
  }))
  default = []
}

# =============================================================================
