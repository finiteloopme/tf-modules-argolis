data "google_project" "gcp_project"{
  project_id = var.project_id
}

data "google_compute_default_service_account" "default_sa" {
    project         = data.google_project.gcp_project.project_id
}

data "google_compute_subnetwork" "vm_subnetwork" {
  name            = var.subnetwork_id
  region          = var.gcp_region
  project         = data.google_project.gcp_project.project_id
}