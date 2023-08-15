module "default-network" {
    source  = "github.com/finiteloopme/tf-modules-argolis//modules/network"
    project_id = module.manage-project-apis.project_id
}

# Create a static IP for MCI (multi cluster ingress) to use
resource "google_compute_global_address" "mci-static-ip" {
  name = "ext-sd-web-ui-mci-ip"
}

# DNS config
module "dns-stable-diffusion-ui" {
  source  = "terraform-google-modules/address/google"

#   subnetwork           = "projects/gcp-network/regions/us-west1/subnetworks/dev-us-west1-dynamic"
#   enable_gcp_dns       = true
  dns_project      = "kunall-dns"
  dns_domain       = "kunall.demo.altostrat.com"
  dns_managed_zone = "kunall-demo"
  region = var.gcp_region
  project_id = module.manage-project-apis.project_id

  names = [
    google_compute_global_address.mci-static-ip.name
  ]

  dns_short_names = [
    "sd"
  ]

  depends_on = [ module.default-network ]
}