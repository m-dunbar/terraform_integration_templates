# ==============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.variables.tf
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

variable "iam_role_list" {
  description = "Map of IAM roles to create"
  type = map(object({
    managed_policy_arns = list(string)
    tags                = optional(map(string), {})
  }))
  default = {
    terraform-provisioner = {
      managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
  }
}

# =============================================================================
