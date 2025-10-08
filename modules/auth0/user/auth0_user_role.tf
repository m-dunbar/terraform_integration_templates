# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0_user_role.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_user_role" "user_role_assignments" {
  for_each = {
    for username, u in var.auth0_users :
    if length(lookup(u, "group_ids", [])) > 0 :
    for gid in lookup(u, "group_ids", []) :
    "${username}_${gid}" => {
      username = username
      gid      = gid
    }
  }

  user_id = auth0_user.this[each.value.username].id
  role_id = each.value.gid
}

# =============================================================================
