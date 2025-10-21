#!/usr/bin/env bash
# =============================================================================
# terraform_integration_templates :: modules/auth0/scripts/get_api_token.sh
#       :: mdunbar :: 2025 Oct 16 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
set -e

# Read JSON from stdin
INPUT=$(</dev/stdin)

# Extract variables from JSON input
DOMAIN=$(echo "$INPUT" | jq -r .domain)
CLIENT_ID=$(echo "$INPUT" | jq -r .client_id)
CLIENT_SECRET=$(echo "$INPUT" | jq -r .client_secret)

response=$(curl --silent --request POST \
  --url "https://${DOMAIN}/oauth/token" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --data "grant_type=client_credentials" \
  --data "client_id=${CLIENT_ID}" \
  --data "client_secret=${CLIENT_SECRET}" \
  --data "audience=https://${DOMAIN}/api/v2/")

token=$(echo "$response" | jq -r .access_token)

# Output JSON with the token
jq -n --arg t "$token" '{"access_token":$t}'