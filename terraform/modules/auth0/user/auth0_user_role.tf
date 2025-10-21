# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0_user_role.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_user_role" "user_role_assignments" {
  for_each = local.user_role_map

  user_id = auth0_user.this[each.value.username].id
  role_id = each.value.gid
}

# =============================================================================
