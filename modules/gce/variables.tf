variable "project_id" {
  description = "ID for the project"
}

variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  default = "us-central1-b"
}

# variable "network_name" {
#   description = "Name of the network, containing the subnet where GCE instance should be launched"
#   default = "default"
# }

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

variable "instance_name" {
  description = "Name for the GCE instance"
}

variable "nat_ip" {
  description = "Public ip address"
  default     = null
}

variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
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

variable "startup_script" {
  description = "Contents of the startup script"
  default = ""
}