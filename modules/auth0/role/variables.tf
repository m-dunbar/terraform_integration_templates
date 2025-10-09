# =============================================================================
# terraform_integration_templates :: modules/auth0/role/variables.tf 
#      :: mdunbar :: 2025 oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "auth0_role_list" {
  description = "List of roles to be created in Auth0"
  type = list(object({
    role_name        = string
    role_description = optional(string)
  }))
}

# =============================================================================
