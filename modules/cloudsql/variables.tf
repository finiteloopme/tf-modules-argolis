variable "project_id" {
  description = "ID for the project"
}

variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "network_name" {
  description = "Name of the parent network of the SQL subnet"
}

variable "subnet_name" {
  description = "Name of the subnet to create the SQL instance within"
}

variable "sql_server_name" {
  description = "Name of the Postgres SQL Server instance"
}

variable "is_public" {
  description = "Does the SQL instance have a public IP?"
  type = bool
  default = false
}

variable "db_tier" {
  description = "DB Tier"
  type = string
  default = "db-custom-1-3840"
}

variable "db_instances" {
  description = "An array with details of DB instances"
  type = list(object({
    name = string,
    collation = string,
    collation = string
  }))
  default = []
}