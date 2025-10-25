# Virtual Private Cloud (VPC)

VPCs are the foundation for many of the most commonly used services, providing a virtual network environment for hosts and microservices.

Leveraging the VPC module, using CIDRs proviosined from our previously defined IPAM pools ensures that any other VPCs that are provisioned from IPAM pools will never result in CIDR collisions.  This also automatically provisions the appropriate supporting resources, providing us with:

## Provisioned resources

- VPC

```text
DEV

us-east-1 VPC: [10.0.48.0/24]
```

- Subnets

```text
Subnets (AZ A): 
 ├─ Private:  10.0.48.0/26
 └─ Public: 10.0.48.64/26
 ```

- Network ACL
- Route Tables (default, private, public)
- Security Group
- Internet Gateway

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
