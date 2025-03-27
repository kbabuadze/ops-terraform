module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = var.vpc_id
  subnet_ids         = module.networking.subnet_ids
  karpenter_version  = var.karpenter_version
}

module "networking" {
  source       = "./modules/networking"
  vpc_id       = var.vpc_id
  subnets      = var.subnets
  cluster_name = var.cluster_name
}
