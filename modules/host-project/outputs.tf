output "host_project_id" {
    value   = data.google_project.project_to_activate.project_id
}
output "host_project_number" {
    value   = data.google_project.project_to_activate.number
}
output "default_sa" {
    value   = data.google_compute_default_service_account.default_sa.email
}
output "config_sa" {
    value   = module.service_accounts.service_account.email
}


