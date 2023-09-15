locals {
  project = "homelab"
  tags = {
    "Project"     = local.project
    "Environment" = "Homelab"
  }
  name = "${local.project}-cluster"
  repo = "https://github.com/Jgeissler14/homelab.git"

  vpc_cidr = "10.0.0.0/16"
  region   = data.aws_region.current.name
  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2]
  ]
}

data "aws_acm_certificate" "issued" {
  domain   = var.acm_certificate_domain
  statuses = ["ISSUED"]
}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

resource "random_password" "argocd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
resource "bcrypt_hash" "argo" {
  cleartext = random_password.argocd.result
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}