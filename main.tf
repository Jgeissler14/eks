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
    source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

    eks_cluster_id        = module.eks.cluster_name
    eks_cluster_endpoint  = module.eks.cluster_endpoint
    eks_cluster_version   = module.eks.cluster_version
    eks_oidc_provider     = module.eks.oidc_provider
    eks_oidc_provider_arn = module.eks.oidc_provider_arn

    # ArgoCD
    enable_argocd                       = true
    argocd_manage_add_ons               = true
    argocd_admin_password_secret_name   = "admin"

    argocd_helm_config = {
        name             = "argo-cd"
        chart            = "argo-cd"
        repository       = "https://argoproj.github.io/argo-helm"
        version          = "3.29.5"
        namespace        = "argocd"
        timeout          = "1200"
        create_namespace = true
        # values = [templatefile("${path.module}/argocd-values.yaml", {})]
    }

    argocd_applications = {
    workloads = {
        path                = "envs/dev"
        repo_url            = "https://github.com/aws-samples/eks-blueprints-workloads.git"
        values              = {}
    }
    addons = {
        path                = "chart"
        repo_url            = "git@github.com:aws-samples/eks-blueprints-add-ons.git"
        add_on_application  = true              # Indicates the root add-on application.
        ssh_key_secret_name = "github-ssh-key"  # Needed for private repos
        values              = {}
    }
    }

    # Add-ons
    # enable_amazon_eks_aws_ebs_csi_driver = true
    enable_aws_load_balancer_controller  = true

    enable_cert_manager                  = true
    cert_manager_domain_names            = ["*.geisslersolutions.com"]

    enable_external_dns                  = true
    external_dns_route53_zone_arns       = [data.aws_route53_zone.default.arn]


    #   enable_karpenter                     = true
    #   enable_metrics_server                = true
    #   enable_argo_rollouts                 = true

    tags = local.tags

    depends_on = [module.eks]
}