output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = module.compute_instance.instances_self_links
}

output "instances_details" {
  description = "List of details for compute instances"
  value       = module.compute_instance.instances_details
  sensitive   = true
}
