module "eks" {
    source       = "./modules/eks"
    cluster_name = local.project

    subnet_ids = [
        data.aws_subnets.default.ids[0],
        data.aws_subnets.default.ids[1],
        data.aws_subnets.default.ids[2]
    ]
}


module "eks_blueprints_addons" {
    # Users should pin the version to the latest available release
    # tflint-ignore: terraform_module_pinned_source
    source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

    eks_cluster_id        = module.eks.cluster_name
    eks_cluster_endpoint  = module.eks.cluster_endpoint
    eks_cluster_version   = module.eks.cluster_version
    eks_oidc_provider     = module.eks.oidc_provider
    eks_oidc_provider_arn = module.eks.oidc_provider_arn

    enable_argocd = true

    # Add-ons
    enable_amazon_eks_aws_ebs_csi_driver = true
    enable_aws_load_balancer_controller  = true
    enable_cert_manager                  = true
    #   enable_karpenter                     = true
    #   enable_metrics_server                = true
    #   enable_argo_rollouts                 = true

    tags = local.tags

    depends_on = [module.eks]
}