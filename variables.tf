variable "cluster_name" {
  type        = string
  default     = "ops-eks-cluster"
  description = "Kubernetes cluster name"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.32"
  description = "Kubernetes version"
}

variable "karpenter_version" {
  type        = string
  default     = "1.3.3"
  description = "Karpenter version"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy the EKS cluster into"
  default     = "vpc-0195ae64d199606ff"
}
