resource "helm_release" "nginx-ingress" {
  name      = "nginx-ingress"
  chart     = "stable/nginx-ingress"
  namespace = "nginx-ingress"
  verify    = false
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  depends_on = ["null_resource.helm-setup"]
}

data "external" "nginx-lb-endpoint" {
  depends_on = ["helm_release.nginx-ingress"]

  program = [
    "bash",
    "${path.module}/files/get_nginx_endpoint.sh",
    local.k8s_context,
  ]
}
