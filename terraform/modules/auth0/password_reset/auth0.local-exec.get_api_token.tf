# =============================================================================
# terraform_integration_templates :: modules/auth0/user/auth0.local-exec.get_api_token.tf
#       :: mdunbar :: 2025 Oct 16 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
data "external" "auth0_api_token" {
  program = ["bash", "${path.module}/scripts/get_api_token.sh"]

  query = {
    domain        = var.auth0_credentials.domain
    client_id     = var.auth0_credentials.client_id
    client_secret = var.auth0_credentials.client_secret
  }
}

output "auth0_api_token" {
  description = "The Auth0 Management API token"
  value       = data.external.auth0_api_token.result.access_token
  sensitive   = true  
}

resource "null_resource" "trigger_password_reset" {
  for_each = { for u in var.auth0_users : u => u }

  provisioner "local-exec" {
    command = <<EOT
      curl -s -X POST "https://${var.auth0_credentials.domain}/api/v2/tickets/password-change" \
        -H "Authorization: Bearer ${data.external.auth0_api_token.result.access_token}" \
        -H "Content-Type: application/json" \
        -d '{"user_id":"${each.value}","result_url":"https://yourapp.com/login"}'
    EOT
  }
}

# =============================================================================
