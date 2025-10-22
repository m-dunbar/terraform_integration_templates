# DynamoDB

DynamoDB is used here to provide a central source for terraform locks.  This prevents terraform state collisions between more than one administrator using terraform at the same time.  Locks are used when performing `plan` and `apply`, to prevent concurrent attempts to modify tfstate, which could result in inconsistant plans or the corruption of the actual tfstate.

# Provioning choices

| Attribute | Value | Reason |
|----------------|-------------|--------|
| billing_mode   | PROVISIONED | Free tier includes up to 25 RCU/WCU per month, PAY-BY-REQUEST has no free tier.  Terraform lock equirements are very small. |
| read_capacity  | 5 | More than sufficient, and well under our free quota limit |
| write_capacity | 5 | More than sufficient, and well under our free quota limit |
| deletion_protection_enabled | true | Accidental deletion of our locks table will break terraform provisioning |
| point_in_time_recovery_enabled | false | There is no need to recover table values. Terraform will automitically create missing rows, as required. |
| server_side_encryption_enabled | true | It is recommended best practice to encrypt all data at rest. |
| server_side_encryption_kms_key_arn | data.aws_kms_alias.terraform.arn | locical referernce to the `terraform` key (via human-friendly alias) |
| ttl_enabled | false | no ttl is required |

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
