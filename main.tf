
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = var.vpc_id
  subnet_ids         = module.networking.subnet_ids
  karpenter_version  = var.karpenter_version
}
module "networking" {
  source                = "./modules/networking"
  vpc_id                = var.vpc_id
  private_subnet_ranges = length(var.private_subnet_ranges) > 0 ? var.private_subnet_ranges : cidrsubnets(cidrsubnets(module.networking.vpc_data.cidr_block, 2, 2)[0], 2, 2)
  public_subnet_ranges  = length(var.public_subnet_ranges) > 0 ? var.public_subnet_ranges : cidrsubnets(cidrsubnets(module.networking.vpc_data.cidr_block, 2, 2)[1], 2, 2)
  cluster_name          = var.cluster_name
}
