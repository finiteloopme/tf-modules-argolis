variable "project_id" {
    description = "Project ID for the DB"
}

variable "db_name" {
    description = "name for the DB"
    type = string
}

variable "firestore_mode" {
    description = "The mode of operation.  FIRESTORE_NATIVE (default) or DATASTORE_MODE"
    default = "FIRESTORE_NATIVE"
}

variable "location_id" {
    description = "Default: us-east1.  Location ID from here: https://cloud.google.com/firestore/docs/locations"
    default = "us-east1"
}

variable "app_engine_integration_mode" {
    description = "default: DISABLED.   The App Engine integration mode to use for this database"
    default = "DISABLED"
}

variable "concurrency_mode" {
    description = "default: OPTIMISTIC.  FIRESORE_NATIVE mode should use OPTIMISTIC, and DATASTORE_MODE should use PESSIMISTIC.  Other option is OPTIMISTIC_WITH_ENTITY_GROUPS"
    default = "OPTIMISTIC"
}