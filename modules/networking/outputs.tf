output "subnet_ids" {
  description = "List of IDs of the subnets"
  value       = aws_subnet.eks_private_subnets[*].id
}

output "vpc_data" {
  description = "VPC data"
  value       = data.aws_vpc.vpc_data
}
