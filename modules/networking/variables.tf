variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "private_subnet_ranges" {
  type        = list(string)
  description = "Subnets to deploy the EKS cluster into"
}

variable "public_subnet_ranges" {
  type        = list(string)
  description = "Subnets to deploy the NAT gateways into"
}
