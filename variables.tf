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
  default     = []
  validation {
    condition     = length(var.private_subnet_ranges) < 3
    error_message = "Public subnet ranges must be provided."
  }
}

variable "public_subnet_ranges" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
  default     = []
  validation {
    condition     = length(var.public_subnet_ranges) < 3
    error_message = "Public subnet ranges must be provided."
  }
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
