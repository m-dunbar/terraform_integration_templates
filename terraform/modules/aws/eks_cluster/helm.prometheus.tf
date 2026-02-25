# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/prometheus.grafana.tf
#       :: mdunbar :: 2026 Feb 24 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  depends_on = [kubernetes_namespace.monitoring]
  namespace  = "monitoring"

  create_namespace = true

  set  = [
    {
    name  = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
    },
   {
      name  = "server.persistentVolume.storageClass"
      value = "gp2"
    }
  ]
}

# =============================================================================
