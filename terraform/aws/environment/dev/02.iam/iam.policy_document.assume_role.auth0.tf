# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.policy_document.assume_role.auth0
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# Policy Document
# ------------------------------
data "aws_iam_policy_document" "assume_role_auth0" {
  statement {
    sid     = "AssumeRoleViaAuth0"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_saml_provider.auth0_saml.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}

# =============================================================================
