variable "project_id" {
  description = "Project hosting the GKE cluster"
}

variable "gke_cluster_name" {
  description = "Name for the GKE cluster"
}

variable "gcp_region" {
  description = "Default region for the resource in this project"
  default = "us-central1"
}

variable "gcp_zone" {
    description = "Default zone for the resources in this region"
    default = "us-centra1-b"
}

variable "network" {
  description = "Network to use for provisioning resources"
  default = "default"
}

variable "subnetwork" {
    description = "Default subnet to use for workload deployment"
    default = "default"
}

variable "gke_network" {
    description = "Name of the subnet which will host GKE cluster"
    default = {
      name: "gke-subnetwork",
      cidr: "10.10.0.0/16"
    }
}
variable "ip_range_pods" {
    description = "CIDR for PODs"
    default = {
      name: "pod-ips-secondary-range",
      cidr: "10.11.0.0/16"
    }
}

variable "svc_ips" {
    description = "CIDR for Services"
    default = {
      name: "svc-ips-secondary-range",
      cidr: "10.12.0.0/16"
    }
}

variable "instance_tags" {
  description = "List of network tags to be applied to the instance"
  type = list(string)
  default = []
}
