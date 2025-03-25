module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"

  cluster_name    = "${var.cluster_name}"
  cluster_version = "1.32"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = "vpc-0195ae64d199606ff"
  subnet_ids = ["subnet-0cd16be2d71b99664", "subnet-06aa1009c4be782d7"]

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 0
      max_size     = 3
    }
  }
}

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name = module.eks.cluster_name

  create_node_iam_role = false
  node_iam_role_arn    = module.eks.eks_managed_node_groups["one"].iam_role_arn

  # Since the node group role will already have an access entry
  create_access_entry = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}



resource "helm_release" "karpenter" {
  name       = "karpenter"
  chart      = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  version    = "1.3.3"
  namespace  = "kube-system"
  
  set {
    name  = "settings.clusterName"
    value = module.eks.cluster_name
  }
  
  set {
    name  = "settings.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }
}

resource "kubectl_manifest" "nodepool" {
  yaml_body = <<YAML
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      nodeClassRef:
        name: default
      requirements:
        - key: "karpenter.k8s.aws/instance-category"
          operator: In
          values: ["t"]
        - key: "topology.kubernetes.io/zone"
          operator: In
          values: ["eu-central-1a", "eu-central-1b"]
        - key: "kubernetes.io/arch"
          operator: In
          values: ["arm64", "amd64"]
  limits:
    cpu: "1000"
    memory: 1000Gi
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "ec2nodeclass" {
  yaml_body = <<YAML
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: AL2
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
YAML

  depends_on = [
    helm_release.karpenter
  ]
}
