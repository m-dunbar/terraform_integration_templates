# =============================================================================
# terraform_integration_templates :: environment/dev/04.dynamodb/dynamodb.variables.tf
#       :: mdunbar :: 2025 Oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

# =============================================================================
