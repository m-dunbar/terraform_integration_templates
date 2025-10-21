# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0.locals.tf
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  # Map of role_name => role object
  role_map = var.auth0_role_objects

  # Step 1: Collect username -> role_name pairs
  user_role_pairs_raw = flatten([
    for u in var.auth0_users : [
      for role_name in lookup(u, "group_ids", []) : {
        username  = u.username
        role_name = role_name
      }
    ]
  ])

  # Step 2: Resolve role objects and IDs safely
  user_role_pairs = [
    for pair in local.user_role_pairs_raw : merge(
      pair,
      {
        role_obj = lookup(local.role_map, pair.role_name, null)
        role_id  = contains(keys(local.role_map), pair.role_name) ? local.role_map[pair.role_name].id : null
      }
    )
  ]

  # Step 3: Build a map keyed by username_role_id, skipping null IDs
  user_role_map = {
    for pair in local.user_role_pairs :
    "${pair.username}_${pair.role_id}" => pair
    if pair.role_id != null
  }
}
# =============================================================================
