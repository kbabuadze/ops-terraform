variable "cluster_name" {
  type        = string
  default     = "ops-eks-cluster"
  description = "Kubernetes cluster name"
}

variable "kubernetes_version" {
  type = string
  default = "1.32"
  description = "Kubernetes version"
}
