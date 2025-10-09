# =============================================================================
# terraform_integration_templates :: auth0/auth0.roles.tf
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "auth0_role" {
  source      = "../modules/auth0/role"
  auth0_role_list = var.auth0_role_list
}

# =============================================================================
