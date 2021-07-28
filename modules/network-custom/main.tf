
data "google_project" "current_gcp_project" {
    project_id          = var.project_id
}

/******************************************
  1. Create a customer network
 *****************************************/
# Create Network
module "custom-network" {
    source  = "terraform-google-modules/network/google//modules/vpc"

    project_id      = data.google_project.current_gcp_project.project_id
    network_name    = var.network_name
    description     = "Custom network for ${var.project_id}"
    routing_mode    = "REGIONAL"
    auto_create_subnetworks = false
}

/******************************************
  2. Create subnet(s)
 *****************************************/
# Create subnet(s)
module "custom-subnets" {
  source            = "terraform-google-modules/network/google//modules/subnets"
  project_id        = var.project_id
  network_name      = var.network_name

  subnets           = var.subnets
  secondary_ranges  = var.secondary_ranges

  depends_on = [
    module.custom-network
  ]
}