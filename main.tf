module "eks" {
    source       = "./modules/eks"
    cluster_name = local.project

    subnet_ids = [
        data.aws_subnets.default.ids[0],
        data.aws_subnets.default.ids[1],
        data.aws_subnets.default.ids[2]
    ]
}



module "eks_blueprints_kubernetes_addons" {
    source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"


    eks_cluster_id        = module.eks.cluster_name
    eks_cluster_endpoint  = module.eks.cluster_endpoint
    eks_cluster_version   = module.eks.cluster_version
    eks_oidc_provider     = module.eks.oidc_provider
    eks_oidc_provider_arn = module.eks.oidc_provider_arn
    

    # enable_amazon_eks_coredns = true
    # amazon_eks_coredns_config = {
    #     most_recent = true
    # }

    # #   enable_amazon_eks_aws_ebs_csi_driver = true
    # #   enable_aws_efs_csi_driver            = true

    # #   enable_prometheus                    = true
    # #   enable_amazon_prometheus             = true
    # #   amazon_prometheus_workspace_endpoint = module.managed_prometheus.workspace_prometheus_endpoint

    # #----------------------------------------------------------------------------------------------------------------------------
    # # Secrets management for iaac - platform admins are expected to upload secrets in secrets manager
    # # ensure there is the appropriate files for csi driver & provider to manage secrets. 
    # # no straggler secrets should exist.
    # enable_secrets_store_csi_driver_provider_aws = false

    # # Secrets management for microservices - application managers are to use vault to store their secrets
    # # they will then be able to render their own secrets to their micro services without
    # # disrupting other processes
    # enable_vault = false
    # vault_helm_config = {
    #     values = [templatefile("${path.module}/helm_values/vault-values.yaml", {})]
    # }
    # #----------------------------------------------------------------------------------------------------------------------------
    # #---------------------------------------------------------------
    # #  External DNS for EKS
    # # ensure eks cluster domain kv is set
    # #---------------------------------------------------------------
    # enable_aws_load_balancer_controller = true
    enable_external_dns                 = true
    eks_cluster_domain                  = var.eks_cluster_domain
    # enable_ingress_nginx                = true
    # ingress_nginx_helm_config = {
    #     values = [templatefile("${path.module}/helm_values/nginx-values.yaml", {
    #     hostname     = var.eks_cluster_domain
    #     ssl_cert_arn = data.aws_acm_certificate.issued.arn
    #     })]
    # }

    # enable_cert_manager = true
    # cert_manager_helm_config = {
    #     create_namespace = true
    #     namespace        = "cert-manager"
    # values = [templatefile("${path.module}/helm_values/certmanager-values.yaml", {})] }
    # cert_manager_install_letsencrypt_issuers = true
    # cert_manager_letsencrypt_email           = "josh@geisslersolutions.com"
    # cert_manager_domain_names                = ["geisslersolutions.com"]
    # #----------------------------------------------------------------------------------------------------------------------------
    # #---------------------------------------------------------------
    # # ArgoCD - GitOps
    # #---------------------------------------------------------------
    # enable_argocd = true
    # argocd_helm_config = {
    #     values = [templatefile("${path.module}/helm_values/argocd-values.yaml", {})]
    #     set_sensitive = [
    #     {
    #         name  = "configs.secret.argocdServerAdminPassword"
    #         value = bcrypt_hash.argo.id
    #     }
    #     ]
    # }

    #---------------------------------------------------------------
    # ArgoCD Applications: the following applications will be deployed
    # to the cluster by ArgoCD. The applications are defined in the
    # argocd_applications variable.
    #---------------------------------------------------------------
    # argocd_applications = {
    #   workloads = local.dev_er_workload
    # }

}