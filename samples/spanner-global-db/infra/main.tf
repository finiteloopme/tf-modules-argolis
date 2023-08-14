resource "google_spanner_instance" "spanner_quote_svc" {
  project = module.manage-project-apis.project_id
  # Global (three continents) service
  config       = "nam-eur-asia3"
  name          = "quote-svc"
  display_name = "Test Spanner Instance"
  # Compute units: 300
  num_nodes    = 3
  labels = {
    "app" = "quote_service",
    "region" = "global",
    "availability" = "99_999pc"
  }
}

resource "google_spanner_database" "quote_svc_db" {
  instance = google_spanner_instance.spanner_quote_svc.name
  name     = "quote-svc-db"
  version_retention_period = "3d"
  ddl = [
    local.DDL_TABLE_SINGERS.value,
    local.DDL_TABLE_ALBUMS.value,
  ]
  deletion_protection = false
}

module "streaming-pubsub-topic" {
  source  = "terraform-google-modules/pubsub/google"
  project_id = module.manage-project-apis.project_id
  create_topic = true
  create_subscriptions = false
  topic = var.pubsub_topic_name
}