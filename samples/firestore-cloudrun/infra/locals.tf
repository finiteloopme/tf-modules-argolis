locals {

  # API services
  project_apis = [
        "compute.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "run.googleapis.com",
        # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
        "serviceusage.googleapis.com",
  ]
}