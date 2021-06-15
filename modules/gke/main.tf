
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke-subnet" {
  source                      = "terraform-google-modules/network/google//modules/subnets"
  project_id                  = var.project_id
  network_name                = var.network

  subnets                     = [
      {
            subnet_name       = var.gke_network.name
            subnet_ip         = var.gke_network.cidr
            subnet_region     = var.gcp_region
      }
  ]

  secondary_ranges            = {
    (var.gke_network.name) = [
      {
        range_name        = var.ip_range_pods.name
        ip_cidr_range     = var.ip_range_pods.cidr
      },
      {
        range_name        = var.svc_ips.name
        ip_cidr_range     = var.svc_ips.cidr
      },
    ]
  }
  
}

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
  subnetwork                  = module.gke-subnet.subnets["${var.gcp_region}/${var.gke_network.name}"].name

  ip_range_pods               = var.ip_range_pods.name
  ip_range_services           = var.svc_ips.name

  create_service_account      = false
  # service_account             = var.compute_engine_service_account

  release_channel             = "REGULAR"

  node_pool_tags              = {
    all = var.instance_tags
  }
}