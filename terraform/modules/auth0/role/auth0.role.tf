# =============================================================================
# terraform_integration_templates :: modules/auth0/role/auth0.role.tf
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_role" "roles" {
  for_each = { for r in local.role_descs : r.role_name => r }

  name        = each.value.role_name
  description = "${each.value.role_description} - Managed by Terraform"
}

# =============================================================================
