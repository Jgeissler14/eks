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
EKS_CLUSTER_NAME=$(terraform output -raw cluster_name)

aws eks --region us-east-1 update-kubeconfig --name $EKS_CLUSTER_NAME

kubectl config get-contexts

kubectl config use-context $EKS_CLUSTER_NAME
```

# ArgoCD Password
Retrieve the argocd secret bcrypt_hash.argo cleartext value in the state file