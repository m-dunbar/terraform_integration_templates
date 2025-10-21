# =============================================================================
# terraform_integration_templates :: auth0/auth0.roles.auto.tfvars
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_role_list = [
  {
    role_name = "dev-Administrator"
    role_description = "Role providing full AWS administrative access"
  },
  {
    role_name = "dev-Developer"
    role_description = "Role providing AWS developer access"
  },
  {
    role_name = "dev-ReadOnly"
    role_description = "Role providing AWS read-only access"
  },
]

# =============================================================================
