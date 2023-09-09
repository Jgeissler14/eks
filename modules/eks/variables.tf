variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to use for the EKS cluster"
  type        = list(string)
}

variable "node_group_desired_size" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}