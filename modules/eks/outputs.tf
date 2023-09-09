output "cluster_name" {
  value = aws_eks_cluster.base.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.base.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.base.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.base.token
}

output "cluster_version" {
  value = aws_eks_cluster.base.version
}

output "oidc_provider" {
  value = aws_eks_cluster.base.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  value = aws_eks_cluster.base.identity[0].oidc[0].issuer
}