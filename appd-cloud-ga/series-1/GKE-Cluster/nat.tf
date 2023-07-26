# A NAT router is needed for egress from the VPC-native, private GKE cluster. 
# Without this, you would not be able to pull images directly from Docker Hub
# or make external service calls from your applications deployed in the cluster.
# Monthly cost of the NAT gateway is about $1 per VM deployed, so for a 3 nodes cluster 
# it costs about $3 per month. For the convenience, it's worth it.
#
# Alternative to NAT would be to use the Google Cloud Artifact Registry to store your
# container images: https://cloud.google.com/artifact-registry/docs/docker/quickstart

resource "google_compute_router" "router" {
  name    = "nat-router"
  project = google_compute_subnetwork.default.project
  region  = google_compute_subnetwork.default.region
  network = google_compute_network.default.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  project                            = google_compute_router.router.project
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
# To address the following error when creating OTel operator:
# failed to create resource: Internal error occurred: failed calling webhook 
# "mopentelemetrycollector.kb.io": failed to call webhook: 
# Post "https://cnao-operators-opentelemetry-operator-webhook.cnao.svc:443/mutate-opentelemetry-io-v1alpha1-opentelemetrycollector?timeout=10s": context deadline exceeded
resource "google_compute_firewall" "gke-opentelemetry-webhook" {
  depends_on = [time_sleep.wait_for_kube]

  project     = var.project_id
  name        = "gke-opentelemetry-webhook-rule"
  network     = "k8s-network"
  description = "Creates firewall rule to allow control plane api server to talk to opentelemetry webhook which uses port 9443"

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }

  source_ranges = ["172.16.0.16/28"]
  #target_tags   = ["gke-k8s-cluster-pods-6ab58d08-node"]
  target_tags = [var.gke_cluster_name]
}
