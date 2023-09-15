output "cluster_name" {
  value = module.eks.cluster_name
}

output "argo_password" {
  value     = random_password.argocd.result
  sensitive = true
}