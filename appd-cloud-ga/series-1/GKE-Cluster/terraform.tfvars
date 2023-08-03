project_id  = "gcp-gcpk8s-nprd-00000"
# Pick a region with low spot VM prices. us-west4 is currently the cheapest.
# Not all regions will work, some don't support STANDARD network tier.
# https://cloud.google.com/compute/vm-instance-pricing
region           = "us-west4"
zone             = "us-west4-c"
gke_cluster_name = "k8s-cluster"
num_nodes        = 3
machine_type     = "e2-standard-2"
disk_size        = 20
network_name     = "k8s-network"
ip_address_name  = "k8s-static-ip"
