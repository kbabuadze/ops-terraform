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

variable "subnets" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy the EKS cluster into"
}
