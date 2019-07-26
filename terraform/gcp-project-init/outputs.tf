output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "nginx_ingress_endpoint" {
  value = data.external.nginx-lb-endpoint.result["endpoint"]
}
