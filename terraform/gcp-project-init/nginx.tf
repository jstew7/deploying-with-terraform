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
