# use terraform cloud
terraform {

   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }
   }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "geisslersolutions"

    workspaces {
      name = "homelab"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
    token                  = module.eks.cluster_token
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  token                  = module.eks.cluster_token
}

#note: useful when needing to manually apply a k8s resource -food for thought-
provider "kubectl" {
  apply_retry_count      = 10
  host                   =  module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  load_config_file       = false
  token                  = module.eks.cluster_token
}

provider "bcrypt" {
}
