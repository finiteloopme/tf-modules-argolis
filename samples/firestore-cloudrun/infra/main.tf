module "firestore_db" {
  source = "../../../modules/fire-store"
  project_id = module.manage-project-apis.project_id
  db_name = "test-fstore-db"
  firestore_mode = "DATASTORE_MODE"
  concurrency_mode = "PESSIMISTIC"
}