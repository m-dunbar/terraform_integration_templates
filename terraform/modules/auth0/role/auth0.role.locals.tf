# =============================================================================
# terraform_integration_templates :: modules/auth0/role/auth0.role.locals.tf
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  role_descs = flatten([
    for r in var.auth0_role_list : [
      {
        role_name        = r.role_name
        role_description = r.role_description != "" ? "${r.role_description} - (Managed by Terraform)" : "(Managed by Terraform)"
      }
    ]
  ])
}

# =============================================================================
