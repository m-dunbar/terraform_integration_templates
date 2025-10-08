# =============================================================================
# terraform_integration_templates :: modules/auth0/group/main.tf :: mdunbar :: 2025 oct 05
# =============================================================================
resource "auth0_group" "this" {
  name = var.name
  description = var.description
}