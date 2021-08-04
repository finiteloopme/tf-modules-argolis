variable "organisation_id" {
  description = "The organization id for the associated services"
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  default     = ""
}

variable "folder_id" {
  description = "Folder ID for the project container"
  default     = ""
}

variable "project_id" {
  description = "ID for the project"
}

variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  default = "us-central1-b"
}

variable "activate_apis" {
  description = "The list of apis to activate for the project"
  type        = list(string)
  default     = [
    "container.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudtrace.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "stackdriver.googleapis.com",
    "anthos.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

variable "anthos_roles"{
  description = "The list of roles required to install Anthos"
  type        = list(string)
  default = [
    "roles/servicemanagement.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/meshconfig.admin",
    "roles/compute.admin",
    "roles/container.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/gkehub.admin",
  ]
}

variable "boolean_org_policies" {
  description = "List of boolean org policies for the project"
  type        = map
  default     = {
    "constraints/compute.requireShieldedVm" = false
    "constraints/compute.requireOsLogin" = false
    "constraints/iam.disableServiceAccountKeyCreation" = false
    "constraints/iam.disableCrossProjectServiceAccountUsage" = false
  }
}

variable "allow_org_policies" {
  description = "List of ALLOW org policies for the project"
  type        = list(string)
  default     = [
    "constraints/compute.vmExternalIpAccess", 
    "constraints/cloudbuild.allowedWorkerPools",
  ]
}

variable "deny_org_policies" {
  description = "List of DENY org policies for the project"
  type        = list(string)
  default     = []
}

variable "project_admin_tf_runner"{
  description = "User with admin rights, who runs this TF"
  type        = string
  default     = "admin@kunall.altostrat.com"
}
