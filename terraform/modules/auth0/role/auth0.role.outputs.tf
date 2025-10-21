# =============================================================================
# terraform_integration_templates :: modules/auth0/role/auth0.role.outputs.tf
#       :: mdunbar :: 2025 Oct 16 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
output "roles" {
  description = "Map of role_name => auth0_role object, including ID"
  value       = { for r_name, r_obj in auth0_role.roles : r_name => r_obj }
}

# =============================================================================
