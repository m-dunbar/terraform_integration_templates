# Relational Database Service (RDS)

Amazon RDS is a managed relational database service that provides scalable, secure, and highly available database instances for development and production workloads.

## Recommendation for High-Availability Production Environments - Aurora

Amazon Aurora is a managed, high-performance relational database compatible with MySQL and PostgreSQL. It is easy to set up, automatically handles backups and failover, and can scale storage and read capacity as needed.

- Managed service – AWS handles maintenance and high availability.
- Scalable – Add read replicas or increase storage automatically.
- Compatible – Works with MySQL or PostgreSQL applications.

Aurora is ideal for production workloads that need high reliability, performance, and scalability, while minimizing operational overhead.

Aurora is worthwhile when

- You need high availability and durability for production workloads.
- You need scalability without manual sharding or replication.
- You need better performance under load than standard RDS MySQL/MariaDB.

## Recommendation for Minimal Development Environments - MariaDB

MariaDB is an open-source relational database compatible with MySQL. It is easy to set up, supports replication and clustering, and provides multiple storage engines for flexibility.

- Open-source – fully community-driven
- MySQL compatible – works with existing MySQL applications
- Flexible – multiple storage engines and replication options

Ideal for development, demos, or production where you want a reliable, fully open-source relational database.

For the Terraform Integration Templates, RDS is implemented using MariaDB with Free Tier instances.

## Terraform security best practice regarding database passwords

Given that passwords should never be specified in clear text and committed to a code repository, best practice would be to configure RDS to use AWS Secrets Manager to store the database admin password, configured with auto-rotation.  

At a _minimum_, password should be defined within an auto.tfvars file listed in .gitignore.

The provided examples implement the use of Secrets Manager for the storage of admin credentials, using a 7-day key rotation.

## Selecting an RDS option

Sample HCL has been provided for implementing both an Aurora cluster and a MariaDB instance.  

Before performing `make plan-rds` or `make rds-apply`, you should activate your preferred RDS implementation (based upon the above recommendations) using either

`make mariadb-active` or `make aurora-active`

If you decide you want the other alternative, you can also deactivate any selection using

`make mariadb-inactive` or `make aurora-inactive`

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
