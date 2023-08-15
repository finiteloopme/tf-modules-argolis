# Create a config cluster
resource "google_container_cluster" "config_cluster" {
  name = local.config_cluster.name
  location = local.config_cluster.region
  project = module.manage-project-apis.project_id

  # Autopilot cluster
  enable_autopilot = true

  network = module.default-network.network
  subnetwork = data.google_compute_subnetwork.config-subnetwork.self_link

}

data "google_compute_subnetwork" "config-subnetwork" {
  name   = "default"
  region = local.config_cluster.region
}

# Create GKE Hub membership for the config cluster
resource "google_gke_hub_membership" "mci_membership" {
  membership_id = "config-membership"
  project = module.manage-project-apis.project_id
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.config_cluster.id}"
    }
  }
  # description = "GKE HUB Membership for config cluster"
}

# Enable MCI feature
resource "google_gke_hub_feature" "mci_feature" {
  name = "multiclusteringress"
  project = module.manage-project-apis.project_id
  location = "global"
  spec {
    multiclusteringress {
      config_membership = google_gke_hub_membership.mci_membership.id
    }
  }
}

# Enable Config Management (confi sync) feature
resource "google_gke_hub_feature" "configsync_feature" {
  name = "configmanagement"
  location = "global"

  labels = {
    foo = "bar"
  }
}