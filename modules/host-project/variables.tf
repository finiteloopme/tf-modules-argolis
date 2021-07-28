variable "organisation_id" {
  description = "The organization id for the associated services"
}

# variable "billing_account" {
#   description = "The ID of the billing account to associate this project with"
# }

# variable "folder_id" {
#   description = "Folder ID for the project container"
# }

variable "project_id" {
  description = "ID for the project"
}

variable "access_context_policy" {
  description = "Name of the access context policy.  gcloud access-context-manager policies list --organization=[org-id]"
  type        = string  
}
variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  default = "us-central1-b"
}

variable "perimeter_name" {
  description = "VPC SC Perimeter name"
  default = "kunall_vpc_sc"
}

variable "activate_apis" {
  description = "The list of apis to activate for the project"
  type        = list(string)
  default     = [
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudtrace.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "stackdriver.googleapis.com",
    "anthos.googleapis.com",
    "cloudbuild.googleapis.com",
    "accesscontextmanager.googleapis.com"
  ]
}

variable "vpc_sc_restricted_services" {
  description = "The list of services restricted by VPC SV"
  type        = list(string)
  default     = [
    "run.googleapis.com"
  ]
}

variable "shared_vpc_roles" {
  description = "The list of roles required to configure Shared VPC"
  type        = list(string)
  default = [
    "roles/compute.xpnAdmin"
  ]
}
# variable "anthos_roles"{
#   description = "The list of roles required to install Anthos"
#   type        = list(string)
#   default = [
#     "roles/servicemanagement.admin",
#     "roles/serviceusage.serviceUsageAdmin",
#     "roles/meshconfig.admin",
#     "roles/compute.admin",
#     "roles/container.admin",
#     "roles/resourcemanager.projectIamAdmin",
#     "roles/iam.serviceAccountAdmin",
#     "roles/iam.serviceAccountKeyAdmin",
#     "roles/gkehub.admin",
#   ]
# }

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

variable "network_name" {
  description = "Name of the network to be created"
  type        = string
  default     = "custom-network"
}

variable "subnets" {
  description = "Array of subnets to be created"
  type        = list(map(string))
  default = [ 
    {
      "subnet_name"           = "subnet-01"
      "subnet_ip"             = "10.10.10.0/24"
      "subnet_region"         = "us-central1"
      "subnet_private_access" = "true"
    }, 
    {
      "subnet_name"           = "subnet-02"
      "subnet_ip"             = "10.10.20.0/24"
      "subnet_region"         = "us-central1"
      "subnet_private_access" = "true"
    }, 
    {
      "subnet_name"           = "subnet-03"
      "subnet_ip"             = "10.10.30.0/24"
      "subnet_region"         = "us-central1"
      "subnet_private_access" = "true"
    }, 
    {
      "subnet_name"           = "subnet-04"
      "subnet_ip"             = "10.10.40.0/24"
      "subnet_region"         = "us-central1"
      "subnet_private_access" = "true"
    }, 
    {
      "subnet_name"           = "subnet-05"
      "subnet_ip"             = "10.10.50.0/24"
      "subnet_region"         = "us-central1"
      "subnet_private_access" = "true"
    }, 
  ]
}
variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}
