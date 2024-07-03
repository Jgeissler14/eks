variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_SECRET_ACCESS_KEY" {}

variable "project" {
  type        = string
  default     = "PaaS"
  description = "Project name"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_types" {
  description = "Instance type for the worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "asg_min_size" {
  description = "Minimum size of the worker node autoscaling group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of the worker node autoscaling group"
  type        = number
  default     = 10
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the worker node autoscaling group"
  type        = number
  default     = 5
}


variable "acm_certificate_domain" {
  type        = string
  default     = "*.cloudzap.co"
  description = "Route53 certificate domain"
}

variable "eks_cluster_domain" {
  type        = string
  default     = "cloudzap.co"
  description = "Route53 domain for the cluster."
}

variable "letsencrypt_email" {
  description = "Email for Let's Encrypt"
  type        = string
  default     = "josh@cloudzap.co"
}