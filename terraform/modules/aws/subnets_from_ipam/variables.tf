# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_subnet/variables.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
variable "vpc_id" {
  description = "ID of the VPC to create subnets in"
  type        = string
}

variable "cluster_label" {
  type        = string
  description = "Label to identify EKS cluster by function (e.g., 'main', '<application>', '<team>')"
  default     = "main"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

variable "number_of_azs" {
  type        = number
  default     = 2
  validation {
    condition     = var.number_of_azs > 0 && var.number_of_azs <= length(data.aws_availability_zones.available.names)
    error_message = "number_of_azs must be positive and not more than available AZs"
  }
}

variable "ipam_pool_id" {
  description = "IPAM Pool ID to request CIDRs from"
  type        = string
}

variable "private_netmask" {
  description = "Netmask size for EKS private subnets"
  type        = number
  default     = 24
}

variable "public_netmask" {
  description = "Netmask size for EKS public subnets (usually smaller)"
  type        = number
  default     = 28
}

# =============================================================================
