# Elastic Kubernetes Service (EKS) -- _**in progress**_

Amazon EKS is Amazon's managed, certified Kubernetes (K8S) service offering, running standard K8S clusters while managing the K8S control plane.

This terraform deploys a standard (albeit extremely small) EKS managed node group (creating supporting control nodes within EC2).  This provides full cluster control, with a lower cost point than Fargate or 'Auto mode' deployment models for persistent clusters.

Normal cluster management tools (`kubectl`, `helm`) can then be used to manage the cluster normally.

Deployments can then proceed using `kubectl deploy`

## EKS Cluster - hashicorp EKS module -- in progress

## Application Stack -- TODO

### implementation - k8s deployment

### supporting plugins - helm

## Observability -- _TODO_

### Prometheus

### Grafana

### Thanos/S3


## Cost Comparison

_(Very basic overview.  Expand later.)_

### EKS Managed Node Group

Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
EC2 Compute costs -- lowest cost model for persistent, predictable loads (and can use spot or reserved instances to further lower costs)

### Fargate

Monthly control plane cost per cluster ($0.10/hour. ~$73/month)

per-vCPU and per-GB memory costs consumed  (generally 2-4x those costs in EC2 -- but, no idle-time overhead costs, so may be cost effective for short, burstable, low volume pods)

### Auto-mode

Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
EC2 compute costs
Auto Mode management fee (10-15% additional overhead)

Auto-scales nodes according to pod-based demand (basically, similar to AWS-managed Karpenter).

Auto-mode provides an on-ramp for teams with little capacity planning expertise expertise.  (_Can_ be lower cost than over-provisioned Managed Node Groups, based upon cluster node autoscaling.)

---

© 2026 Matthew Dunbar  
(See LICENSE for details.)
