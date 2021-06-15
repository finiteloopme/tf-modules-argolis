module "gke-subnet" {
  source                      = "terraform-google-modules/network/google//modules/subnets"
  project_id                  = var.project_id
  network_name                = var.network

  subnets                     = [
      {
            subnet_name       = var.gke_network.name
            subnet_ip         = var.gke_network.cidr
            subnet_region     = var.gke_network.gcp_region
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
