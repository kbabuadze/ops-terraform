variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
}

variable "karpenter_version" {
  type        = string
  description = "Karpenter version"
}
