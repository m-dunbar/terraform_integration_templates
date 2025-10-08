# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0_user.tf
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_user" "this" {
  for_each = { for user in var.auth0_users : user.username => user }

  connection_name = var.connection_name
  username        = each.value.username
  given_name      = each.value.given_name
  nickname        = lookup(each.value, "nickname", null)
  family_name     = each.value.family_name
  name            = lookup(each.value, "name", "${each.value.given_name} ${each.value.family_name}")
  email           = each.value.email
  password        = lookup(each.value, "password", null)
  email_verified  = lookup(each.value, "email_verified", false)
  phone_number    = lookup(each.value, "phone_number", null)
  phone_verified  = lookup(each.value, "phone_verified", false)
  verify_email    = lookup(each.value, "verify_email", true)
  blocked         = lookup(each.value, "blocked", false)
}

# =============================================================================
