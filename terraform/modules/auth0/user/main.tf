# =============================================================================
# terraform_integration_templates :: modules/auth0/user/main.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "random_password" "this" {
  for_each = { for user in var.auth0_users : user.username => user }

  length  = 16
  special = true
  override_special = "!@#$%^&*()-_=+[]{}<>?"
}

resource "auth0_user" "this" {
  for_each = { for user in var.auth0_users : user.username => user }

  connection_name = var.connection_name
  username        = each.value.username
  given_name      = each.value.given_name
  nickname        = lookup(each.value, "nickname", null)
  family_name     = each.value.family_name
  name            = "${each.value.given_name} ${each.value.family_name}"
  email           = each.value.email
  password        = random_password.this[each.key].result
  phone_number    = lookup(each.value, "phone_number", null)
  phone_verified  = lookup(each.value, "phone_verified", false)
  blocked         = lookup(each.value, "blocked", false)
}

resource "auth0_user_role" "user_role_assignments" {
  for_each = local.user_role_map

  user_id = try(
    lookup(auth0_user.this, each.value.username, null),
    null
  ).id

  role_id = try(
    lookup(local.role_map, each.value.role_name, null),
    null
  ).id

  lifecycle {
    ignore_changes = [
      role_id
    ]
  }
}

# =============================================================================
