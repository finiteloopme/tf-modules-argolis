# Create a config cluster
resource "google_container_cluster" "gke_cluster" {
  name = var.cluster_name
  location = var.region
  project = var.project_id

  # Autopilot cluster
  enable_autopilot = true

  network = var.network
  subnetwork = data.google_compute_subnetwork.gke-subnetwork.self_link
}

data "google_compute_subnetwork" "gke-subnetwork" {
  name   = "default"
  region = var.region
}

# Create GKE Hub membership for the config cluster
resource "google_gke_hub_membership" "mci_gke_membership" {
  membership_id = "mci-membership-${var.cluster_name}"
  project = var.project_id
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.gke_cluster.id}"
    }
  }
  # description = "GKE HUB Membership for config cluster"
}

resource "google_gke_hub_feature_membership" "feature_member" {
  location = "global"
  feature = var.config_sync_feature
  membership = google_gke_hub_membership.mci_gke_membership.membership_id
  configmanagement {
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo = "https://github.com/finiteloopme/tf-modules-argolis"
        sync_branch = "main"
        policy_dir = "samples/autopilot-with-mci/app/stable-diffusion"
        sync_wait_secs = "20"
        sync_rev = "HEAD"
        secret_type = "none"
      }
    }
  }
  provider = google-beta
}