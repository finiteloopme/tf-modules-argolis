data "google_project" "gcp_project"{
  project_id = var.project_id
}

data "google_compute_default_service_account" "default_sa" {
    project         = data.google_project.gcp_project.project_id
}

# data "google_compute_network" "default_network" {
#   name = var.network_name
# }

data "google_compute_subnetwork" "vm_subnetwork" {
  # self_link         = "projects/kunal-scratch/regions/us-central1/subnetworks/default"
  # name            = "${var.subnetwork_id}-${var.gcp_region}"
  name            = var.subnetwork_id
  region          = var.gcp_region
  project         = data.google_project.gcp_project.project_id
}

output "subnet"{
    value   = data.google_compute_subnetwork.vm_subnetwork.self_link
}
