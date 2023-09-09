resource "aws_eks_cluster" "base" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "base" {
  cluster_name    = aws_eks_cluster.base.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  depends_on = [aws_eks_cluster.base]
}


resource "aws_eks_cluster_auth" "base" {
  name = aws_eks_cluster.base.name
  depends_on = [aws_eks_cluster.base]
}