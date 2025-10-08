resource "aws_iam_saml_provider" "auth0_saml" {
  name                   = "auth0-saml-provider"
  saml_metadata_document = file("auth0-metadata.xml")
}