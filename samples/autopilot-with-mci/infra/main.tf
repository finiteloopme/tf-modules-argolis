# Create individual clusters & register them for MCI
module "gke_clusters" {
  source = "./gke"
  for_each = local.cluster_locations
  project_id = module.manage-project-apis.project_id
  cluster_name = "gke-${each.key}"
  region = each.key
  network = module.default-network.network
  config_sync_feature = google_gke_hub_feature.configsync_feature.name

  depends_on = [ google_container_cluster.config_cluster ]
}

