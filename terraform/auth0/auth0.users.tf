# =============================================================================
# terraform_integration_templates :: auth0/auth0.users.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "auth0_user" {
  source             = "../modules/auth0/user"
  auth0_users        = var.auth0_users
  auth0_role_list    = var.auth0_role_list 
  auth0_role_objects = module.auth0_role.roles   # Pass the full role objects

  depends_on = [module.auth0_role]
}

# module "auth0_password_reset" {
#   source = "../modules/auth0/password_reset"
#   auth0_users = var.auth0_users
#   auth0_credentials = {
#       client_id     = var.auth0_saml_client_id
#       client_secret = var.auth0_saml_client_secret
#       domain        = var.auth0_domain
#     }
# }

# =============================================================================
