module "eks" {
    source = "./modules/eks"
    cluster_name = local.project

    subnet_ids = toset(data.aws_subnets.default.ids)
}
 
module "helm" {
    source = "./modules/helm"
    
    domain = var.domain

    depends_on = [module.eks]
}