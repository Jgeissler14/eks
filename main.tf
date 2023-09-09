module "eks" {
    source = "./modules/eks"
    cluster_name = local.project

    subnet_ids = [
        data.aws_subnet_ids.default.ids[0],
        data.aws_subnet_ids.default.ids[1],
        data.aws_subnet_ids.default.ids[2]
    ]
}
 
module "helm" {
    source = "./modules/helm"
    
    domain = var.domain

    depends_on = [module.eks]
}