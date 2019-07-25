variable "project_id" {

}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "k8s_cluster_name" {
  default = "demo-cluster"
}

variable "k8s_node_count" {
  default = 2
}

variable "master_authorized_ip" {
  description = "IP Address to authorize access to k8s master nodes"
}
