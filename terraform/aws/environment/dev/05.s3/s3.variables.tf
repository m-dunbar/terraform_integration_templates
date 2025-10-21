# =============================================================================
# terraform_integration_templates :: environment/dev/05.s3/s3.variables.tf
#       :: mdunbar :: 2025 Oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "bootstrap_plan" {
  type        = bool
  description = "Set as true if performing initial bootstrap plan prior to creating kms key."
  default     = false  
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

# =============================================================================
