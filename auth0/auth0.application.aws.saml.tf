# =============================================================================
# terraform_integration_templates :: auth0/auth0.application.aws.saml.tf 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# Auth0 SAML Identity Provider (IdP) for AWS
# -------------------------------------
resource "auth0_client" "aws_saml" {
  name        = "AWS SAML App"
  app_type    = "regular_web"
  description = "AWS SSO via SAML"
  callbacks   = ["https://signin.aws.amazon.com/saml"]

  addons {
    samlp {
      audience                           = "https://signin.aws.amazon.com/saml"
      name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
    }
  }
}

resource "auth0_action" "aws_role_mapping" {
  name    = "aws-role-mapping"
  runtime = "node18"
  deploy  = true

  code = <<EOF
exports.onExecutePostLogin = async (event, api) => {
  const roles = event.user?.app_metadata?.aws_roles || [];
  if (!roles || !roles.length) return;

  // Ensure we have an array of role strings
  const vals = Array.isArray(roles) ? roles : [roles];

  // Only call SAML API if available in this trigger/context
  if (api.saml && typeof api.saml.addAttribute === "function") {
    api.saml.addAttribute("https://aws.amazon.com/SAML/Attributes/Role", vals);
    api.saml.addAttribute("https://aws.amazon.com/SAML/Attributes/RoleSessionName", event.user.user_id || "");
  }
};
EOF

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }
}

# =============================================================================
