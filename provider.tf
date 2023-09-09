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
}