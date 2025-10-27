# =============================================================================
# terraform_integration_templates :: terraform/auth0/auth0.application.aws.oidc.tf
#       :: mdunbar :: 2025 Oct 27 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_client" "aws_oidc" {
  name             = "AWS OIDC App"
  app_type         = "non_interactive"   # machine-to-machine
  description      = "AWS CLI / Automation via OIDC"
  oidc_conformant  = true
}

# =============================================================================
