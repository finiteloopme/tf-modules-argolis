output "host_project_id" {
    value   = data.google_project.project_to_activate.project_id
}
output "project_number" {
    value   = data.google_project.project_to_activate.number
}

output "default_account" {
    value   = data.google_compute_default_service_account.default_sa.email
}

