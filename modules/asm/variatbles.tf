variable "project_id" {
  description = "Project hosting the GKE cluster"
}

variable "gke_cluster" {
  description = "Name of the GKE cluster"
}

variable "gkp_location" {
  description = "Location (region/zone) name of where GKE cluster resides"
}