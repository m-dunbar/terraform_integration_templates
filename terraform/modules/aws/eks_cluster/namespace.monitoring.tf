# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/namespace.monitoring.tf
#       :: mdunbar :: 2026 Feb 24 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# =============================================================================
