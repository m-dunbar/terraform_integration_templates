# AWS Key Management Service (KMS)

Unsurprisingly, provides centralized management of encryption keys.

In this example, a Custom KMS key, and supporting key alias (`terraform`) have been created, for use encrptying the contents of the bucket in S3 where a centralized tfstate backend (including a hierarchical folder structure for tfstate files) will be maintained, and for the terrform_locks dynamodb table, used to prevent terraform management collisions from more than one administrator being applied simultaneously.

## TODO

While the initial `terraform` key is sufficient for initial implementation, any additional keys that may be needed later should also be managed here.

- add a kms.keys.tf template, along with supporting variables declaration, and a list of additional keys to be maintained.

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
