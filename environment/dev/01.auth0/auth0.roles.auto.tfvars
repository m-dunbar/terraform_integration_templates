# =============================================================================
# terraform_integration_templates :: environment/dev/01.auth0/auth0.roles.auto.tfvars
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_role_list = [
  {
    role_name = "Administrator"
    role_description = "Role providing full AWS administrative access"
  },
  {
    role_name = "Developer"
    role_description = "Role providing AWS developer access"
  },
  {
    role_name = "ReadOnly"
    role_description = "Role providing AWS read-only access"
  },
]

# =============================================================================
