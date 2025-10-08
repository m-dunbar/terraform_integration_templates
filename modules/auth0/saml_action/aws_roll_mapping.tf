# =============================================================================
# terraform_integration_templates :: modules/auth0/saml_action/aws_roll_mapping.tf
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "auth0_action" "aws_role_mapping" {
  name    = "AWS-Role-Mapping-${var.environment}"
  runtime = "node18"
  deploy  = true

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  code = templatefile("${path.module}/templates/aws_role_mapping.js.tpl", {
    environment       = var.environment
    timestamp         = timestamp()
    auth0_group_to_aws_role_arn_map = var.auth0_group_to_aws_role_arn_map
  })
}

# =============================================================================
