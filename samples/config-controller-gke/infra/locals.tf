locals {

    conf_controller_name = "gke-config-controller"
    # kube-clusters = toset([
    #     "gke-us-east1", 
    #     "gke-us-central1", 
    #     "gke-us-west1", 
    #     "gke-australia-southeast1", 
    #     "gke-europe-west2"])
  regions    = toset(["us-central1", "us-east1", "europe-west2", "australia-southeast1"]) # used to create network configuration below

  # API services
  project_apis = [
        "compute.googleapis.com",
        "container.googleapis.com",
        "gkehub.googleapis.com",
        "anthosconfigmanagement.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "cloudbilling.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
        "serviceusage.googleapis.com",
  ]
  # Network configuration
  network_name     = "${var.app_name}-network" # VPC containing resources will be given this name
  network = { for region in local.regions : region =>
    {
      subnet                = "${var.app_name}-${region}-gke-subnet"
      name                  = "${region}"
      gke-cluster           = "gke-${region}"
    } 
  }
  subnets = [
    {
      subnet_name           = local.network.us-central1.subnet
      subnet_ip             = "10.0.0.0/16"
      subnet_region         = local.network.us-central1.name
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.us-east1.subnet
      subnet_ip             = "10.1.0.0/16"
      subnet_region         = local.network.us-east1.name
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.europe-west2.subnet
      subnet_ip             = "10.2.0.0/16"
      subnet_region         = local.network.europe-west2.name
      subnet_private_access = true
    },
    {
      subnet_name           = local.network.australia-southeast1.subnet
      subnet_ip             = "10.3.0.0/16"
      subnet_region         = local.network.australia-southeast1.name
      subnet_private_access = true
    },
  ]


}