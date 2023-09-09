# use terraform cloud
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
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
        host                   = module.eks.eks_cluster_endpoint
        cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority)
        token                  = module.eks.cluster_token
    }
}