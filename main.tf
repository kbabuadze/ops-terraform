resource "kubernetes_manifest" "node_class" {
  manifest = yamldecode(file("./karpenter-nodeclass.yaml"))
}

resource "kubernetes_manifest" "node_pool" {
  manifest = yamldecode(file("./karpenter-nodepool.yaml"))
}
