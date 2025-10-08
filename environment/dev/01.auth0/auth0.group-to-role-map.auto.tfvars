# =============================================================================
# terraform_integration_templates :: environment/dev/auth0/auth0.group-to-role-map.auto.tfvars
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_group_to_aws_role_map = [
  { auth0_group = "Administrators", aws_role_name = "Administrators" },
  { auth0_group = "Developers",     aws_role_name = "Developers" },
]

# =============================================================================
