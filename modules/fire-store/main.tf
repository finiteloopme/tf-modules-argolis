# Enable Firestore API
module "firestore_api" {
    source = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/manage-gcp-apis"
    project_id = var.project_id
    project_apis = local.project_apis
}

# Create the DB
resource "google_firestore_database" "firestore_db" {
    project = module.firestore_api.project_id
    name = var.db_name
    location_id = var.location_id
    type = var.firestore_mode # Mobile/Web mode or Server mode?
    concurrency_mode = var.concurrency_mode # Optimistic or pessimistic?
    app_engine_integration_mode = var.app_engine_integration_mode # Disabled is the default
}