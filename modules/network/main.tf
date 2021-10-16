
data "google_project" "current_gcp_project" {
    project_id          = var.project_id
}

/******************************************
  3. Create `default` network
 *****************************************/
# Create Network
module "default-network" {
    source  = "terraform-google-modules/network/google//modules/vpc"

    project_id      = data.google_project.current_gcp_project.project_id
    network_name    = var.network_name
    description     = "Default Network"
    routing_mode    = "GLOBAL"
    auto_create_subnetworks = true
}

# Create Firewall rule to allow SSH, HTTPs, HTTP
module "firewall-rule-allow-ssh-http-s" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = data.google_project.current_gcp_project.project_id
  network_name = var.network_name

  rules = [{
    name                    = "allow-ssh-https-ingress"
    description             = "Allow SSH & HTTP(s)"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      # ssh, http/s, Postgres
      ports    = ["22", "80", "443", "8080","8443", "5432", "15021"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]

  depends_on  = [
    module.default-network
  ]
}

# Create Firewall rule to allow internal 
module "firewall-rule-default-allow-internal" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = data.google_project.current_gcp_project.project_id
  network_name = var.network_name

  rules = [{
    name                    = "default-allow-internal"
    description             = "Allow Internal traffic"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["10.128.0.0/9"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22-65535"]
    },
    {
      protocol = "udp"
      ports    = ["22-65535"]
    },
    {
      protocol = "icmp"
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]

  depends_on  = [
    module.default-network
  ]
}
