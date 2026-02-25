# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/grafana.tf
#       :: mdunbar :: 2026 Feb 24 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
# Provision secure random password for Grafana admin user
ephemeral "random_password" "grafana_admin" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}<>:?"
}

# Create a SecretsManager key
resource "aws_secretsmanager_secret" "grafana_admin" {
  name        = "${local.cluster_name}/grafana/admin"
  description = "Grafana admin password for ${local.cluster_name}"
}

# Store the random password securely in SecretsManager
resource "aws_secretsmanager_secret_version" "grafana_admin_value" {
  secret_id             = aws_secretsmanager_secret.grafana_admin.id
  secret_string_wo      = jsonencode({
    password = ephemeral.random_password.grafana_admin.result # prevents writing to tfstate
  }) 
  secret_string_wo_version = 1
}

# Create the required manifest for the grafana admin password ExternalSecret
resource "kubernetes_manifest" "grafana_external_secret" {
  depends_on = [
    kubernetes_manifest.external_secrets_store,
    aws_secretsmanager_secret_version.grafana_admin_value
  ]

  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"

    metadata = {
      name      = "${local.cluster_name}-grafana-admin"
      namespace = "monitoring"
    }

    spec = {
      refreshPolicy = "OnChange"

      secretStoreRef = {
        name = kubernetes_manifest.external_secrets_store.manifest["metadata"]["name"]
        kind = "SecretStore"
      }

      target = {
        name = "${local.cluster_name}-grafana-admin"
      }

      data = [
        {
          secretKey = "admin-user"
          remoteRef = {
            # EXACT AWS Secrets Manager secret name
            key      = aws_secretsmanager_secret.grafana_admin.name
            # EXACT field inside that secret JSON
            property = "username"
          }
        },
        {
          secretKey = "admin-password"
          remoteRef = {
            key      = aws_secretsmanager_secret.grafana_admin.name
            property = "password"
          }
        }
      ]
    }
  }
}

# Configure Grafana Helm chart with admin password from Kubernetes secret
resource "helm_release" "grafana" {
  depends_on = [
    helm_release.external_secrets,
    kubernetes_manifest.grafana_external_secret
  ]

  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"

  set = [
    {
      # Sets the name of the Kubernetes secret that contains admin credentials
      name  = "admin.existingSecret"
      value = "${local.cluster_name}-grafana-admin"    },
    {
      # In that Kubernetes secret, the key that holds the admin username
      name  = "admin.userKey"
      value = "admin-user"
    },
    {
      # In that Kubernetes secret, the key that holds the admin password
      name  = "admin.passwordKey"
      value = "admin-password"
    },
    {
      # Set which StorageClass Grafana persistence should use
      name  = "persistence.storageClassName"
      value = "gp2"
    },
    {
      # Set the Kubernetes Service type (LoadBalancer, NodePort, ClusterIP, etc.)
      name  = "service.type"
      value = "LoadBalancer"
    }
  ]
}# =============================================================================
