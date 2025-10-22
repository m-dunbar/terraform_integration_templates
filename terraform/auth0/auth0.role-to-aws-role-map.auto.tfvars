# =============================================================================
# terraform_integration_templates :: auth0/auth0.group-to-role-map.auto.tfvars
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_role_to_aws_role_map = [
  { auth0_role = "dev-Administrator", aws_role_name = "Administrator" },
  { auth0_role = "dev-Developer",     aws_role_name = "Developer" },
  { auth0_role = "dev-ReadOnly",     aws_role_name = "ReadOnly" },
]

# =============================================================================
