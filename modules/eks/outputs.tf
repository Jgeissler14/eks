output "eks_cluster_name" {
  value = aws_eks_cluster.base.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.base.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.base.certificate_authority[0].data
}

output "cluster_token" {
  value = aws_eks_cluster_auth.base.token
}