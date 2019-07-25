resource "google_container_cluster" "primary" {
  provider = "google-beta"
  name     = var.k8s_cluster_name
  # Just want a zonal cluster (single cluster master) so stuff it in A zone
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {} # Basic auth disabled

  private_cluster_config {
    # Allow external access to master
    enable_private_endpoint = false
    # Allow external access to nodes, if this is enabled you'll have to setup NAT for nodes to talk external
    enable_private_nodes = false
    # If you have more than 1 cluster you will have to configure this CIDR so they are different
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "${var.master_authorized_ip}/32"
    }
  }

  ip_allocation_policy {
    node_ipv4_cidr_block = "" # Let it compute values
    create_subnetwork    = true
    subnetwork_name      = "gke-${var.k8s_cluster_name}-subnet"
  }
}

resource "google_container_node_pool" "primary_node_pool" {
  provider   = "google-beta"
  name       = "${var.k8s_cluster_name}-primary-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.k8s_node_count

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# Delay because it takes a few seconds for the cluster endpoint to accept traffic
resource "null_resource" "kube-delay" {
  triggers = {
    after = "${google_container_node_pool.primary_node_pool.id}"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

# Use gcloud SDK to add kubectl config context for created cluster
resource "null_resource" "kube-config" {
  depends_on = ["null_resource.kube-delay"]

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.k8s_cluster_name} --zone ${var.zone} --project ${var.project_id}"
  }
}
