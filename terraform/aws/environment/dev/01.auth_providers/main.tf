# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/01.saml/main.tf
#       :: mdunbar :: 2025 Oct 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "auth0_metadata_xml" {
  source = "../../../../modules/auth0/metadata"

  auth0_domain    = var.auth0_domain
  auth0_client_id = var.auth0_client_id
}

output "auth0_metadata_xml" {
  value = module.auth0_metadata_xml.auth0_metadata_xml
}

# resource "aws_iam_openid_connect_provider" "auth0_oidc" {
#   url = "https://YOUR_DOMAIN.auth0.com/"

#   client_id_list = [
#     auth0_client.aws_oidc.client_id
#   ]

#   thumbprint_list = [
#     "YOUR_AUTH0_ROOT_CA_THUMBPRINT"
#   ]
# }

resource "aws_iam_saml_provider" "auth0_saml" {
  name                   = "auth0-saml-provider"
  saml_metadata_document = module.auth0_metadata_xml.auth0_metadata_xml
}

# =============================================================================
