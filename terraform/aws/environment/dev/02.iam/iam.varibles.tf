# ==============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.variables.tf
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

variable "iam_role_list" {
  description = "List of IAM roles to create"
  type = list(object({
    role_name = string
    policies  = map(string)
    tags      = optional(map(string), {})
  }))
}

# =============================================================================
