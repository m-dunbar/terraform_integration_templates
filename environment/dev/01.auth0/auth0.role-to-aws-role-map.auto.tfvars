# =============================================================================
# terraform_integration_templates :: environment/dev/auth0/auth0.group-to-role-map.auto.tfvars
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_role_to_aws_role_map = [
  { auth0_role = "Administrators", aws_role_name = "Administrators" },
  { auth0_role = "Developers",     aws_role_name = "Developers" },
]

# =============================================================================
