locals {

  # API services
  project_apis = [
        "compute.googleapis.com",
        "container.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "dns.googleapis.com",
        "spanner.googleapis.com",
        "pubsub.googleapis.com",
        "dataflow.googleapis.com",
        # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
        "serviceusage.googleapis.com",
        "logging.googleapis.com",
        "gkehub.googleapis.com",
        "multiclusterservicediscovery.googleapis.com",
        "multiclusteringress.googleapis.com",
        "trafficdirector.googleapis.com",
  ]

  config_cluster = {
    name = "config-cluster",
    region = var.gcp_region
  }

  # GKE Autopilot Config
  cluster_locations = toset([
    "us-east1",
    "asia-east1",
    "asia-southeast2",
    "australia-southeast1",
    "europe-west2",
    "europe-west4",
    "us-central1",
    "us-west1",
    ])
  
  clusters = {
    for location in local.cluster_locations : location => {
      name = "gke-${location}",
      region = "${location}"
    }
  }
}