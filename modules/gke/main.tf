
data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }

module "gke-subnet"{
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/subnet"
  project_id                  = var.project_id
  network                     = var.network
  gke_network                 = var.gke_instance.subnet.name
  ip_range_pods               = var.gke_instance.secondary_ranges.pod_ips.name
  svc_ips                     = var.gke_instance.secondary_ranges.svc_ips.name

}

module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  project_id                  = var.project_id
  name                        = var.gke_instance.name

  initial_node_count          = 4

  regional                    = true # Create a regional cluster
  region                      = var.gcp_region
  # zones                       = [var.gcp_zone]
  network                     = var.gke_instance.subnet.name
  # subnetwork                  = var.subnetwork
  subnetwork                  = module.gke-subnet.subnets["${var.gcp_region}/${var.gke_instance.subnet.name}"].name
  # subnetwork                  = var.gke_network.name

  ip_range_pods               = var.gke_instance.secondary_ranges.pod_ips.name
  ip_range_services           = var.gke_instance.secondary_ranges.svc_ips.name

  create_service_account      = false
  # service_account             = var.compute_engine_service_account

  release_channel             = "REGULAR"

  node_pools_tags              = {
    all = var.instance_tags
  }
}