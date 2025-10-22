# =============================================================================
# terraform_integration_templates :: terraform/modules/auth0/metadata/meta.data.tf
#       :: mdunbar :: 2025 Oct 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
data "external" "auth0_metadata" {
  program = [
    "bash",
    "-c",
    "jq -n --arg xml \"$(curl -s 'https://${var.auth0_domain}/samlp/metadata/${var.auth0_client_id}')\" '{metadata: $xml}'"
  ]
}

output "auth0_metadata_xml" {
  value = data.external.auth0_metadata.result.metadata
}

# =============================================================================
