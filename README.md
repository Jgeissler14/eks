# Terraform EKS Cluster Deployment
## Prerequisites:

AWS CLI installed and configured.
Terraform (version >= 0.12).
AWS account with access keys.
ACM Certificiate created for your domain
Usage:

Clone this repository.

Navigate to the directory with main.tf.

Run terraform init.

Create a Terraform execution plan: terraform plan.

Apply the plan: terraform apply.

Review the created resources.

## Terraform Variable Configuration

The following variables can be configured in terraform.tfvars or as environment variables.

| Variable | Description | Default |
| --- | --- | --- |
| aws_region | AWS region | us-east-1 |
| acm_certificate_arn | ACM certificate ARN for the cluster | "" |
| eks_cluster_domain_name | Domain name for the cluster | "" |

## Terraform Outputs

| Output | Description |
| --- | --- |
| cluster_name | EKS cluster name |
| argo_password | ArgoCD password |

## Terraform Modules
### VPC Module
Creates a VPC with subnets and NAT gateways

### EKS Module (module "eks")
Sets up an EKS cluster with node groups.
Configures security groups.

### EKS Blueprints Kubernetes Addons Module (module "eks_blueprints_kubernetes_addons")
Deploys Kubernetes addons using Helm.
Enables extensions like Prometheus and ArgoCD.

## Configuration
Customize settings in variables.tf as needed.

## Managing ArgoCD Applications
Applications are managed with ArgoCD in helm/argocd/workloads.

### App of Apps Pattern

The "App of Apps" pattern allows you to manage multiple applications through a single ArgoCD application. In the code provided, the `argocd_applications` block in `eks_blueprints_kubernetes_addons` defines applications to be deployed to the EKS cluster using git ArgoCD. Each application can have its Helm chart path, repository URL, and values.
To add an Application, add a file to [Templates](./helm/argocd/workloads/templates)

### Deploying Applications to Specific Domains

To deploy applications to specific domains, you can use annotations in the Helm chart values. For example, refer to [VaultWarden Example](./helm/argocd/workloads/templates/vaultwarden.yaml)

# ArgoCD Password
Retrieve the argocd password from the terraform outputs, the username is admin

### Cleanup
To destroy resources, run: terraform destroy.

# License
This script is under the MIT License (LICENSE.md).
