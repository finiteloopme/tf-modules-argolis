locals {
  environments    = toset(["dev", "staging", "prod"]) # used to create network configuration below
  network_name     = "${var.app_name}-network" # VPC containing resources will be given this name
  network = { for env in local.environments : env =>
    {
      subnetwork_cr              = "${var.app_name}-${env}-cloudrun-subnet"
      subnetwork_sql             = "${var.app_name}-${env}-cloudsql-subnet"
    } 
  }
  subnets = [
    {
      subnet_name           = local.network.dev.subnetwork_cr
      subnet_ip             = "10.0.0.0/16"
      subnet_region         = var.gcp_region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.staging.subnetwork_cr
      subnet_ip             = "10.1.0.0/16"
      subnet_region         = var.gcp_region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.prod.subnetwork_cr
      subnet_ip             = "10.2.0.0/16"
      subnet_region         = var.gcp_region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.dev.subnetwork_sql
      subnet_ip             = "10.3.0.0/16"
      subnet_region         = var.gcp_region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.staging.subnetwork_sql
      subnet_ip             = "10.4.0.0/16"
      subnet_region         = var.gcp_region
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.prod.subnetwork_sql
      subnet_ip             = "10.5.0.0/16"
      subnet_region         = var.gcp_region
      subnet_private_access = true
    },
  ]
}