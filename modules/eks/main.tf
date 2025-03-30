data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    eks-pod-identity-agent = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    critical_workload = {
      ami_type = "AL2_x86_64"

      min_size     = 1
      max_size     = 2
      desired_size = 2

      taints = {
        critical_workload = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
}
