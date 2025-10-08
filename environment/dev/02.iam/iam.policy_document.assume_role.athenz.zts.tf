# =============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.policy_document.assume_role.auth0
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# Policy Document
# ------------------------------
data "aws_iam_policy_document" "assume_role_auth0" {
  statement {
    sid     = "AssumeRoleViaAuth0"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/auth0_saml_provider"]
    }
  }
}

# =============================================================================
