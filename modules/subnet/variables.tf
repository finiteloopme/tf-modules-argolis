variable "project_id" {
  description = "Project hosting the GKE cluster"
}

variable "network" {
  description = "Network to use for provisioning resources"
  default = "default"
}

variable "gcp_region" {
  description = "Region where subnet should be created"
  default = "us-central1"
}

variable "gke_network" {
    description = "Name of the subnet which will host GKE cluster"
    default = {
      name: "gke-subnetwork",
      cidr: "10.10.0.0/16",
      subnet_region: var.gcp_region
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
