# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/variables.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
variable "cluster_label" {
  type        = string
  description = "Label to identify EKS cluster by function (e.g., 'main', '<application>', '<team>')"
  default     = "main"

  validation {
    condition     = can(regex("^[A-Za-z0-9\\-_]+$", var.cluster_label))
    error_message = "cluster_label must only contain alphanumeric, hyphen, or underscore."
  }
}

variable "eks_managed_node_groups" {
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
  }))
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9\\-_]+$", var.environment))
    error_message = "environment must only contain alphanumeric, hyphen, or underscore."
  }
}

variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "subnet_ids" {
  description = "List of subnet IDs in which the cluster and nodes will operate"
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to EKS cluster and node groups"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

# =============================================================================
