# =============================================================================
# terraform_integration_templates :: environment/dev/auth0/auth0.users.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "auth0_user" {
  source = "../../../modules/auth0/user"
  auth0_users = var.auth0_users
}

# =============================================================================
