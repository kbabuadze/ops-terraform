resource "kubectl_manifest" "node_class" {
  yaml_body = templatefile("./templates/karpenter/nodeclass.tpl", {
    cluster_name = var.cluster_name
  })
}

resource "kubectl_manifest" "node_pool" {
  yaml_body = templatefile("./templates/karpenter/nodepool.tpl", {
    cluster_name = var.cluster_name
  })
}
