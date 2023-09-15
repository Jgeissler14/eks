module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 5.0"

    name = "${local.project}-vpc"
    cidr = local.vpc_cidr

    azs             = local.azs
    private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
    public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

    enable_nat_gateway = true
    single_nat_gateway = true

    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
    }

    tags = local.tags
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.16"

    cluster_name                   = "${local.project}-cluster"
    cluster_version                = "1.27"
    cluster_endpoint_public_access = true

    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    

    eks_managed_node_groups = {
        initial = {
            instance_types = ["t3.small"]

            min_size     = 1
            max_size     = 5
            desired_size = 3 # When < 3, the coredns add-on ends up in a degraded state
        }
    }

    #  EKS K8s API cluster needs to be able to talk with the EKS worker node
    node_security_group_additional_rules = {
        ingress_self_all = {
            description = "Node to node all ports/protocols"
            protocol    = "-1"
            from_port   = 0
            to_port     = 0
            type        = "ingress"
            self        = true
            }
        # Recommended outbound traffic for Node groups
        egress_all = {
            description      = "Node all egress"
            protocol         = "-1"
            from_port        = 0
            to_port          = 0
            type             = "egress"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
        }
    }

    tags = local.tags
}


module "eks_blueprints_kubernetes_addons" {
    source = "aws-ia/eks-blueprints-addons/aws"

    eks_cluster_id               = module.eks.cluster_name
    eks_cluster_endpoint         = module.eks.cluster_endpoint
    eks_oidc_provider            = module.eks.oidc_provider
    eks_cluster_version          = module.eks.cluster_platform_version
    

    eks_addons = {
        coredns = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
    }

    # enable_prometheus                    = true
    # enable_amazon_prometheus             = true
   
    enable_aws_load_balancer_controller = true

    #---------------------------------------------------------------
    #  External DNS for EKS
    # ensure eks cluster domain kv is set
    #---------------------------------------------------------------
    enable_external_dns                 = true
    eks_cluster_domain                  = var.eks_cluster_domain

    enable_cert_manager = true
    cert_manager_helm_config = {
        create_namespace = true
        namespace        = "cert-manager"
        values = [templatefile("${path.module}/helm_values/cert-manager/certmanager-values.yaml", {})] }
    
    cert_manager_install_letsencrypt_issuers = true
    cert_manager_letsencrypt_email           = "josh@geisslersolutions.com"
    cert_manager_domain_names                = [var.eks_cluster_domain]

    #----------------------------------------------------------------------------------------------------------------------------
    #---------------------------------------------------------------
    # ArgoCD - GitOps
    #---------------------------------------------------------------
    enable_argocd = true
    argocd_helm_config = {
        values = [templatefile("${path.module}/helm_values/argocd/argocd-values.yaml", {
            domain = var.eks_cluster_domain
        })]
        set_sensitive = [
        {
            name  = "configs.secret.argocdServerAdminPassword"
            value = bcrypt_hash.argo.id
        }
        ]
    }

    depends_on = [
        module.eks
    ]
}
 