variable "host_project_id" {
  description = "Project which hosts the config connector"
}

variable "config_connector_region" {
  description = "Region in which config connector should be hosted"
  default     = "us-central1"
}

variable "config_connecor_id"{
  description = "ID for the config connector to be created"
}

variable "activate_apis" {
  description = "The list of apis to activate for the project"
  type        = list(string)
  default     = [
    "krmapihosting.googleapis.com"
  ]
}

# variable "project_id" {
#   description = "Project targeted to be configured via config-connector"
# }
