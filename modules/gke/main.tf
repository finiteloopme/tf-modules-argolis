
data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }

module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  project_id                  = var.project_id
  name                        = var.gke_cluster_name

  initial_node_count          = 4

  regional                    = true # Create a regional cluster
  region                      = var.gcp_region
  # zones                       = [var.gcp_zone]
  network                     = var.network
  # subnetwork                  = var.subnetwork
  # subnetwork                  = module.gke-subnet.subnets["${var.gcp_region}/${var.gke_network.name}"].name
  subnetwork                  = var.gke_network.name

  ip_range_pods               = var.ip_range_pods.name
  ip_range_services           = var.svc_ips.name

  create_service_account      = false
  # service_account             = var.compute_engine_service_account

  release_channel             = "REGULAR"

  node_pools_tags              = {
    all = var.instance_tags
  }
}