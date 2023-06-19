module "dev-cloud-sql" {
  source = "../../../modules/cloudsql"

  project_id = var.project_id
  network_name = local.network_name
  subnet_name = local.network.dev.subnetwork_sql
  sql_server_name = "testing123"

  depends_on = [ module.app-network ]
}