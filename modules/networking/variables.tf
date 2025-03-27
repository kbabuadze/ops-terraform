variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
}
