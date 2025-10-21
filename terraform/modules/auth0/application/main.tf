# ===============================================================================
# terraform_integration_templates :: modules/auth0/application/variables.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_client" "aws_saml_app" {
  name             = var.name
  app_type         = "regular_web"
  callbacks        = var.callbacks
  oidc_conformant  = false
}

resource "auth0_action" "aws_role_mapping" {
  name    = "aws-role-mapper"
  runtime = "node18"
  
  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  code = file("${path.module}/aws_role_mapping.js")
}

# =============================================================================
