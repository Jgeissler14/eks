module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

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

  cluster_name                   = local.name
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_addons = {
    aws-ebs-csi-driver = {}
    coredns            = {}
    kube-proxy         = {}
    vpc-cni            = {}
  }


  eks_managed_node_groups = {
    initial = {
      instance_types = var.instance_types

      min_size     = var.asg_min_size
      max_size     = var.asg_max_size
      desired_size = var.asg_desired_capacity
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
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_platform_version

  enable_kube_prometheus_stack        = true
  enable_metrics_server               = true
  enable_aws_cloudwatch_metrics       = true
  enable_vpa                          = true
  enable_aws_efs_csi_driver           = true
  enable_aws_load_balancer_controller = true

  #---------------------------------------------------------------
  #  External DNS for EKS
  # ensure eks cluster domain kv is set
  #---------------------------------------------------------------
  enable_external_dns = true
  eks_cluster_domain  = var.eks_cluster_domain

  enable_cert_manager = true
  cert_manager_helm_config = {
    create_namespace = true
    namespace        = "cert-manager"
  values = [templatefile("${path.module}/helm/cert-manager/certmanager-values.yaml", {})] }

  cert_manager_install_letsencrypt_issuers = true
  cert_manager_letsencrypt_email           = var.letsencrypt_email
  cert_manager_domain_names                = [var.eks_cluster_domain]

  #----------------------------------------------------------------------------------------------------------------------------
  #---------------------------------------------------------------
  # ArgoCD - GitOps
  #---------------------------------------------------------------
  enable_argocd = true
  argocd_helm_config = {
    values = [templatefile("${path.module}/helm/argocd/argocd-values.yaml", {
      domain       = "${var.eks_cluster_domain}",
      acm_cert_arn = "${data.aws_acm_certificate.issued.arn}",
    })]
    set_sensitive = [
      {
        name  = "configs.secret.argocdServerAdminPassword"
        value = bcrypt_hash.argo.id
      }
    ]
  }

  #---------------------------------------------------------------
  # ArgoCD Applications: the following applications will be deployed
  # to the cluster by ArgoCD. The applications are defined in the
  # argocd_applications variable.
  #---------------------------------------------------------------
  argocd_applications = {
    workloads = {
      path               = "helm/argocd/workloads"
      repo_url           = local.repo
      add_on_application = false
      values = {
        spec = {
          source = {
            repoURL = local.repo
          }
          blueprint   = "terraform"
          clusterName = local.name
        }
      }
    }
  }

  depends_on = [
    module.eks
  ]
}

