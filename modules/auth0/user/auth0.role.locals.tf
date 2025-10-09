# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0.locals.tf
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  user_role_pairs = flatten([
    for u in var.auth0_users : [
      for gid in lookup(u, "group_ids", []) : {
        username = u.username
        gid      = gid
      }
    ]
  ])

  user_role_map = {
    for pair in local.user_role_pairs :
    "${pair.username}_${pair.gid}" => pair
  }
}

# =============================================================================
