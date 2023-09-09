# Kubernetes Homelab
This 'homelab' is my personal collection of projects

## Projects

## Base
The kubernetes cluster is provisioned via terraform to create the following
- EKS Cluster

The cluster is then configured via helm to install the following
- cert-manager


## Services

## Cluster Login
```
aws eks --region us-east-1 update-kubeconfig --name "$EKS_CLUSTER_NAME"

kubectl config get-contexts

kubectl config use-context "$EKS_CLUSTER_NAME"
```