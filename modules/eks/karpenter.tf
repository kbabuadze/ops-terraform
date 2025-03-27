module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.34.0"

  cluster_name          = var.cluster_name
  enable_v1_permissions = true

  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = var.cluster_name
  create_pod_identity_association = true
  enable_pod_identity             = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  depends_on = [module.eks]
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  chart      = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  version    = var.karpenter_version
  namespace  = "kube-system"

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "settings.clusterCertificateAuthorityData"
    value = module.eks.cluster_certificate_authority_data
  }

  set {
    name  = "settings.replicas"
    value = 1
  }

  depends_on = [module.eks]
}


resource "kubectl_manifest" "node_class" {
  yaml_body = templatefile("${path.module}/templates/karpenter/nodeclass.tpl", {
    cluster_name = var.cluster_name
  })
  depends_on = [module.karpenter]
}

resource "kubectl_manifest" "node_pool" {
  yaml_body = templatefile("${path.module}/templates/karpenter/nodepool.tpl", {
    cluster_name = var.cluster_name
  })
  depends_on = [module.karpenter]
}
