# An simple way for calling modules to wait for API activation
output "project_id" {
    value       = module.manage-project-apis.project_id
    depends_on = [ time_sleep.wait_for_gcp_services ]
}