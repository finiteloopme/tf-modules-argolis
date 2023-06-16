module "private-service-access-sql" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project_id
  vpc_network = var.network_name
}

data "google_compute_network" "sql-parent-network" {
  name = var.network_name
  project = var.project_id
}

data "google_compute_subnetwork" "sql-subnet" {
    project = var.project_id
    name = var.subnet_name
}

module "cloudsql_staging" {
  source = "GoogleCloudPlatform/sql-db/google//modules/postgresql"

  project_id = var.project_id
  region     = var.gcp_region

  name                = var.sql_server_name
  database_version    = "POSTGRES_14"
  enable_default_db   = false
  tier                = var.db_tier
  deletion_protection = false
  availability_type   = "REGIONAL"
  zone                = "${var.gcp_region}-b"

  ip_configuration = {
  "ipv4_enabled": false,
  "require_ssl": null,
  "authorized_networks": [],
  "allocated_ip_range": data.google_compute_subnetwork.sql-subnet.name,
  "private_network": data.google_compute_network.sql-parent-network.self_link
  # "private_network": "projects/${var.project_id}/global/networks/${data.google_compute_subnetwork.sql-subnet.network}"
  #"enable_private_path_for_google_cloud_services": true
  }

  # additional_databases = var.db_instances

  user_name     = "admin"
  user_password = "admin" # this is a security risk - do not do this for real world use-cases!

  module_depends_on = [module.private-service-access-sql.peering_completed]
}