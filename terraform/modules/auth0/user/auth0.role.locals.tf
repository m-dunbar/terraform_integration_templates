# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0.locals.tf
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  # Map Auth0 role name → role ID from the auth0_role module outputs
  role_id_map = { for name, role_obj in var.roles : name => role_obj.id }

  user_role_pairs = flatten([
    for u in var.auth0_users : [
      for gid in lookup(u, "group_ids", []) : {
        username = u.username
        gid      = local.role_id_map[gid]   # <--- map the role name to ID
      }
    ]
  ])

  user_role_map = {
    for pair in local.user_role_pairs :
    "${pair.username}_${pair.gid}" => pair
  }
}

# =============================================================================
