
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}


provider "kubectl" {
  apply_retry_count      = 15
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "/bin/sh"
    args = [
      "-c",
      "aws eks get-token --cluster-name ${var.cluster_name} --output json"
    ]
  }
}
