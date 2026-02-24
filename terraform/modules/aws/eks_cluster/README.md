# eks_cluster

This is an example of a local module which sets specific default 'baseline' cluster parameters, while still utilizing the HashiCorp provided [Terraform EKS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest).

## Default parameters

```bash
  instance_type = "t3.medium"

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
    }
  }
```

---

© 2026 Matthew Dunbar  
(See LICENSE for details.)
