# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.roles.auto.tfvars
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
iam_role_list = [
  {
    role_name = "Administrators"
    policies = {
     "AdministratorAccess" = "arn:aws:iam::aws:policy/AdministratorAccess",
    }
  },
  {
    role_name = "Developers"
    policies = {
      "PowerUserAccess" = "arn:aws:iam::aws:policy/PowerUserAccess",
    }
  },
  {
    role_name = "ReadOnly"
    policies = {
      "ReadOnlyAccess" = "arn:aws:iam::aws:policy/ReadOnlyAccess",
    }
  },
]

# =============================================================================
