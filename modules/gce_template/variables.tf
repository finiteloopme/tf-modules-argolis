variable "project_id" {
  description = "ID for the project"
}

variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "subnetwork_id" {
  description = "Subnet ID where GCE instance should be launched"
  default = "default"
}

variable "service_account" {
  description = "Service Account to be assigned to the GCE instance"
  default = ""
}

variable "machine_type" {
  description = "Type of GCE instance to be used. https://cloud.google.com/compute/docs/machine-types"
  default = "c2-standard-8"
}

variable "source_image_family" {
  description = "Family of the source image to be used.  E.g. debian-10, debina-9, centos-8, cos-89-lts, etc"
  default     = "debian-10"
}

variable "source_image_project" {
  description = "Project of the source image to be used.  E.g. debian-cloud centos-cloud, cos-cloud, etc"
  default     = "debian-cloud"
}

variable "instance_tags" {
  description = "List of network tags to be applied to the instance"
  type = list(string)
  default = [
    "http",
    "https",
  ]
}

variable "metadata" {
  description = "Contents of the startup script"
  type        = map(string)
  default     = {}
}