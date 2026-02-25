# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/helm.external-secrets.tf
#       :: mdunbar :: 2026 Feb 25 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
resource "helm_release" "external_secrets" {
  depends_on = [aws_secretsmanager_secret_version.grafana_admin_value]

  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"
  create_namespace = true

  # you can layer any values file or overrides here
  version    = "2.0.1"
}

resource "kubernetes_manifest" "external_secrets_store" {
  depends_on = [
    helm_release.external_secrets
  ]

  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "SecretStore"
    metadata = {
      name      = "aws-secretsmanager"
      namespace = "external-secrets"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.region

          # Optional: IRSA JWT auth if you want ESO to assume a role
          # Uncomment + fill out if you added IRSA to helm_release.external_secrets
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = helm_release.external_secrets.name
                namespace = helm_release.external_secrets.namespace
              }
            }
          }
        }
      }
    }
  }
}

# =============================================================================
