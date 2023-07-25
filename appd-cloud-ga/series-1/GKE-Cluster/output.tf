output "gke_cluster_name" {
  value = google_container_cluster.default.name
}

output "gke_cluster_kubernetes_version" {
  value = google_container_cluster.default.master_version
}
