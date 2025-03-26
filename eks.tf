data "aws_eks_cluster" "cluster" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  # Gives Terraform identity admin access to cluster which will
  # allow deploying resources (Karpenter) into the cluster
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    eks-pod-identity-agent = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.eks_subnets[*].id

  eks_managed_node_groups = {
    critical_workload = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      labels = {
        "karpenter.sh/controller" = "true"
      }

      taints = {
        critical_workload = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "eks_subnets" {
  count                   = length(var.subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name"                   = "eks-subnet-${count.index}",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}

resource "aws_security_group" "eks_cluster" {
  vpc_id = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    "Name"                   = "eks-cluster",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}
