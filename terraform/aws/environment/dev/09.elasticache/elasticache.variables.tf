# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/09.elasticache/elasticache.variables.tf
#       :: mdunbar :: 2025 Dec 01 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

# =============================================================================
