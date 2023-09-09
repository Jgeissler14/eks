variable "AWS_ACCESS_KEY_ID" {}

variable "AWS_SECRET_ACCESS_KEY" {}

variable "domain" {
  description = "The domain name to use for the cluster"
  type        = string
  default     = "*.geisslersolutions.com"
}