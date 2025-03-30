variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "ops-eks-cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.32"
}

variable "karpenter_version" {
  type        = string
  description = "Karpenter version"
  default     = "1.3.3"
}

variable "private_subnet_ranges" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "public_subnet_ranges" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy the EKS cluster into"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}
