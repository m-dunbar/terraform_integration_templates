# ===============================================================================
# terraform_integration_templates :: modules/auth0/application/variables.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================

variable "name"{ 
  type = string 
  description = "The name of the Auth0 group"
}

variable "callbacks" {
  type        = list(string)
  description = "Allowed callback URLs for the Auth0 application"
}

# =============================================================================
