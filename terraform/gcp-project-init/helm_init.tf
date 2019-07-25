resource "kubernetes_service_account" "tiller" {
  depends_on = ["null_resource.kube-config"]
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  depends_on = ["null_resource.kube-config"]
  metadata {
    name = "tiller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "system:serviceaccount:kube-system:tiller"
    namespace = "kube-system"
  }
}

resource "null_resource" "helm-setup" {
  depends_on = ["kubernetes_service_account.tiller", "kubernetes_cluster_role_binding.tiller"]

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"
    command    = "helm reset"
  }
}
