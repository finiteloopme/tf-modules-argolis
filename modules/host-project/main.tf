
/******************************************
  0. Create a service account
 *****************************************/
# module "org-policy-act-as-SA" {
#     source          = "terraform-google-modules/iam/google//modules/organizations_iam"
#     organizations   = [var.organisation_id]
#     mode            = "additive"
#     bindings        = {
#       "roles/iam.serviceAccountUser" = [
#           "user:${var.project_admin_tf_runner}",
#       ]
#     }
# }

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = ">= 3.0"
  project_id    = var.project_id
  prefix        = "tf"
  names         = ["config-sa"]
  display_name  = "TF Managed Service Account"
  description   = "TF Managed Service Account for Infra As Code"
  # grant_xpn_roles = true
  project_roles = [
    "${var.project_id}=>roles/owner",
  ]
}

# module "service_account-iam-bindings" {
#   source        = "terraform-google-modules/iam/google//modules/service_accounts_iam"
#   project       = var.project_id
#   service_accounts  = ["${module.service_accounts.iam_email}"]
#   mode          = "additive"
#   bindings      = {
#       "roles/iam.serviceAccountTokenCreator" = [
#           "user:${var.project_admin_tf_runner}",
#       ]
#       "roles/iam.serviceAccountUser" = [
#           "user:${var.project_admin_tf_runner}",
#       ]
#   }

#   depends_on = [
#     module.service_accounts
#   ]
# }
resource "google_service_account_iam_binding" "sa-token-creator" {
  service_account_id = module.service_accounts.service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "user:${var.project_admin_tf_runner}",
  ]
}
resource "google_service_account_iam_binding" "sa-user" {
  service_account_id = module.service_accounts.service_account.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "user:${var.project_admin_tf_runner}",
  ]
}

/******************************************
  1. Grant Org Policy Admin role to the TF Runner
 *****************************************/

resource "google_organization_iam_binding" "policy_admin" {
  org_id  = var.organisation_id
  role    = "roles/orgpolicy.policyAdmin"

  members = [
    "user:${var.project_admin_tf_runner}",
    "${module.service_accounts.iam_email}"
  ]
}

resource "google_organization_iam_binding" "access_context_admin" {
  org_id  = var.organisation_id
  role    = "roles/accesscontextmanager.policyAdmin"

  members = [
    "user:${var.project_admin_tf_runner}",
    "${module.service_accounts.iam_email}"
  ]
}

resource "google_organization_iam_binding" "xpn_admin" {
  org_id  = var.organisation_id
  role    = "roles/compute.xpnAdmin"

  members = [
    "user:${var.project_admin_tf_runner}",
    "${module.service_accounts.iam_email}"
  ]
}

provider "google" {
}

data "google_client_config" "default" {
  provider = google
}

data "google_service_account_access_token" "default" {
  provider               = google
  target_service_account = "${module.service_accounts.email}"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "3000s"
  depends_on = [
    resource.google_service_account_iam_binding.sa-token-creator,
    resource.google_service_account_iam_binding.sa-user,
      resource.google_organization_iam_binding.policy_admin,
      resource.google_organization_iam_binding.access_context_admin,
      resource.google_organization_iam_binding.xpn_admin,
  ]
}

provider "google" {
  alias        = "impersonated"
  access_token = data.google_service_account_access_token.default.access_token
}

data "google_client_openid_userinfo" "me" {
  provider = google.impersonated
}

output "target-email" {
  value = data.google_client_openid_userinfo.me.email
}

/******************************************
  2. Enable required APIs for the project
 *****************************************/
# Get Project
data "google_project" "project_to_activate" {
    project_id          = var.project_id
    depends_on = [
      resource.google_organization_iam_binding.policy_admin,
      resource.google_organization_iam_binding.access_context_admin,
      resource.google_organization_iam_binding.xpn_admin,
    ]
}

# Activate APIs
module "project-services" {
    source          = "terraform-google-modules/project-factory/google//modules/project_services"
    project_id      = data.google_project.project_to_activate.project_id

    activate_apis   = var.activate_apis
}

# Set the required Org Policies for the project
# Boolean policies
module "org-policies-boolean" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  for_each          = var.boolean_org_policies
  project_id        = data.google_project.project_to_activate.project_id
  constraint        = each.key
  policy_type       = "boolean"
  enforce           = each.value
  depends_on        = [
      resource.google_organization_iam_binding.policy_admin,
      resource.google_organization_iam_binding.access_context_admin,
      resource.google_organization_iam_binding.xpn_admin,
  ]
}
# Allow list = ALL
module "org-policies-allow-list" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  for_each          = toset(var.allow_org_policies)
  project_id        = data.google_project.project_to_activate.project_id
  constraint        = each.key
  policy_type       = "list"
  enforce           = false
  depends_on        = [
      resource.google_organization_iam_binding.policy_admin,
      resource.google_organization_iam_binding.access_context_admin,
      resource.google_organization_iam_binding.xpn_admin,
  ]
}
# Deny list = ALL
module "org-policies-deny-list" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  for_each          = toset(var.deny_org_policies)
  project_id        = data.google_project.project_to_activate.project_id
  constraint        = each.key
  policy_type       = "list"
  enforce           = true
  depends_on        = [
      resource.google_organization_iam_binding.policy_admin,
      resource.google_organization_iam_binding.access_context_admin,
      resource.google_organization_iam_binding.xpn_admin,
  ]
}

/******************************************
  3. Enable 'Host" project
 *****************************************/
resource "google_compute_shared_vpc_host_project" "host_project" {
  provider = google-beta

  project = data.google_project.project_to_activate.project_id

  depends_on = [
    module.project-services,
    module.org-policies-boolean,
    module.org-policies-allow-list,
    module.org-policies-deny-list]
}

/******************************************
  4. Create a network and required subnets
 *****************************************/
# Create Network
module "network-and-subnets" {
  source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/network-custom"
  # source            = "../network-custom"

  project_id      = data.google_project.project_to_activate.project_id
  network_name    = var.network_name
  subnets         = var.subnets
}

/******************************************
  4. Get the default service account
 *****************************************/
data "google_compute_default_service_account" "default_sa" {
    project         = data.google_project.project_to_activate.project_id
  depends_on = [
    module.project-services
  ]
}


/******************************************
  4. Configure firewall rules
 *****************************************/
module "firewall-rule-vpc-connector" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = data.google_project.project_to_activate.project_id
  network_name = var.network_name

  rules = [
    # Allow SSH & HTTP(S) Ingress
    {
      name                    = "allow-ssh-https-ingress"
      description             = "Allow SSH & HTTP(s)"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        # ssh, http/s
        ports    = ["22", "80", "443", "8080", "8443"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    # Allow ingress from VPC connector to other resource on n/w
    {
      name                    = "allow-vpc-conn-ingress"
      description             = "Allow ingress from VPC connector to other resource on n/w"
      direction               = "INGRESS"
      priority                = null
      ranges                  = null
      source_tags             = ["vpc-connector"]
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = null
        },
        {
          protocol = "udp"
          ports    = null
        },
        {
          protocol = "icmp"
          ports    = null
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    # Allow ingress from health check to VPC connector
    {
      name                    = "allow-ingress-hc-to-vpc-conn"
      description             = "Allow ingress from health check to VPC connector"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["130.211.0.0/22","35.191.0.0/16","108.170.220.0/23"]
      source_tags             = ["vpc-connector"]
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["667"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    # Allow Egress from VPC Connector to Serverless
    {
      name                    = "allow-egress-vpc2cr"
      description             = "Allow Egress from VPC Connector to Serverless"
      direction               = "EGRESS"
      priority                = null
      ranges                  = ["107.178.230.64/26","35.199.224.0/19"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["vpc-connector"]
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["667"]
        },
        {
          protocol = "udp"
          ports    = ["665-666"]
        },
        {
          protocol = "icmp"
          ports    = null
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    # Allow ingress from Serverless to VPC Connector
    {
      name                    = "allow-ingress-cr2vpcc"
      description             = "Allow ingress from Serverless to VPC Connector"
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["107.178.230.64/26","35.199.224.0/19"]
      source_tags             = ["vpc-connector"]
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["667"]
        },
        {
          protocol = "udp"
          ports    = ["665-666"]
        },
        {
          protocol = "icmp"
          ports    = null
        },
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
  ]

  depends_on    = [
    module.network-and-subnets
  ]
}

/******************************************
  5. Configure VPC SC
 *****************************************/
# Service Perimeter
resource "google_access_context_manager_service_perimeters" "service-perimeter" {
  provider = google.impersonated
  parent = "accessPolicies/${var.access_context_policy}"

  service_perimeters {
    name            = "accessPolicies/${var.access_context_policy}/servicePerimeters/${var.perimeter_name}"
    title           = var.perimeter_name
    description     = "Service Perimeter for Kunall Altostrat"
    perimeter_type  = "PERIMETER_TYPE_REGULAR"
    status {
      resources           = ["projects/${data.google_project.project_to_activate.number}"]
      restricted_services = var.vpc_sc_restricted_services
    }
  }
}