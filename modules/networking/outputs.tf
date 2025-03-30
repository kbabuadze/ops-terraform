output "subnet_ids" {
  description = "List of IDs of the subnets"
  value       = aws_subnet.eks_private_subnets[*].id
}
