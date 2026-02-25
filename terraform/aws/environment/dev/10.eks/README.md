# Elastic Kubernetes Service (EKS) -- _**in progress**_

Amazon EKS is Amazon's managed, certified Kubernetes (K8S) service offering, running standard K8S clusters while managing the K8S control plane.

This terraform deploys a standard (albeit extremely small) EKS managed node group (creating supporting control nodes within EC2).  This provides full cluster control, with a lower cost point than Fargate or 'Auto mode' deployment models for persistent clusters.

Standard cluster management tools (`kubectl`, `helm`) can then be used to manage the cluster normally.

Deployments can proceed using `kubectl deploy`, `terraform apply`, or CI/CD pipeline.

## EKS Cluster

Cluster creation is performed by calling a local module 'aws/eks_cluster', which includes standardized configuration elements (example: a monitoring namespace), and adding and configuring supporting observability components (prometheus, grafana).

## Application Stack -- TODO

### implementation - k8s deployment

## Supporting plugins (via helm)

**External Secrets Operator (ESO)** [chart: external-secrets] -- populates Kubernetes Secrets from AWS Secrets Manager

## Observability -- _in progress_

_Currently working through the `terraform plan` 'chicken and egg' of having to have the Custom Resource Definitions already installed in order for `plan` to evaluate the supporting helm manifests that will configure ESO and grafana._

_This can be brute forced with multiple  plan/apply passes, but a cleaner solution is desired._

### Prometheus

Installed and configured via modules/aws/eks_cluster/helm.prometheus.tf

### Grafana

Installed and configured via modules/aws/eks_cluster/helm.grafana.tf

_[add example access link to grafana web interface -- add a script to plumb it for direct cluster access (more secure) via a local URL querym or additional infrastructure to reach it via load balancer (an option used to expose dashboards to a larger audience)]_

### Thanos/S3 -- _TODO_

Thanos provides long term metrics storage in S3, allowing metrics analysis against long term historical performance.

### Karpenter -- _TODO_

_(A reach objective integration example - scaling sufficiently to demonstrate may be somewhat more expensive.)_

## Cost Comparisons of different EKS deployment models

_(Very basic overview.  Expand later.)_

### EKS Managed Node Group -- the model implemented here

- Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
- EC2 Compute costs

The lowest cost model for persistent, predictable loads (and can use spot or reserved instances to further lower costs).  

Ideally, implementing Karpenter to provide horizontal node-level autoscaling to further reduce overhead, using relevant metrics for determining upscaling and downscaling, in addition to node rightsizing (vertical scaling) provides optimal cost management.

### Fargate

- Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
- per-vCPU and per-GB memory costs consumed (generally 2-4x those costs in EC2)

Often considerably more expensive for persistant, predicatable loads, but the Fargate model eliminates idle-time overhead costs, so may be cost effective for short, burstable, low volume pods.

### Auto-mode

- Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
- EC2 compute costs
- Auto Mode management fee (10-15% additional overhead)

Auto-scales nodes according to pod-based demand (basically, similar to AWS-managed Karpenter).

Auto-mode provides an on-ramp for teams with little capacity planning expertise expertise.  It _can_ be lower cost than over-provisioned Managed Node Groups, based upon potential savings via cluster node autoscaling.

---

© 2026 Matthew Dunbar  
(See LICENSE for details.)
