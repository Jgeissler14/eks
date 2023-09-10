locals {
  project = "homelab"
  tags = {
    "Project"     = local.project
    "Environment" = "Homelab"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_route53_zone" "default" {
  name = var.domain
}