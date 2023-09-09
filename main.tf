module "eks" {
    source = "./modules/eks"
    cluster_name = local.project

    subnet_ids = [
        data.aws_subnets.default.ids[0],
        data.aws_subnets.default.ids[1],
        data.aws_subnets.default.ids[2]
    ]
}
 
module "helm" {
    source = "./modules/helm"
    
    domain = var.domain

    eks_cluster_endpoint = module.eks.eks_cluster_endpoint
    eks_cluster_certificate_authority = module.eks.eks_cluster_certificate_authority
    cluster_token = module.eks.cluster_token

    depends_on = [module.eks]
}