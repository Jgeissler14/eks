variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_SECRET_ACCESS_KEY" {}

##-----------------------------------
## acm var - external dns
##-----------------------------------
variable "acm_certificate_domain" {
  type        = string
  description = "Route53 certificate domain"
}
##-----------------------------------
## nginx var - external dns
##-----------------------------------
variable "eks_cluster_domain" {
  type        = string
  description = "Route53 domain for the cluster."
}