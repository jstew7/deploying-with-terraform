provider "google" {
  project = var.project_id
  region  = var.region
  version = "~> 2.11"
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  version = "~> 2.11"
}

locals {
  k8s_context = "gke_${var.project_id}_${var.zone}_${var.k8s_cluster_name}"
}

provider "helm" {
  version = "~> 0.10"
  kubernetes {
    config_context = local.k8s_context
  }
  install_tiller  = true
  service_account = "tiller"
}

provider "kubernetes" {
  version                = "~> 1.8"
  config_context_cluster = local.k8s_context
}

provider "null" {
  version = "~> 2.1"
}
