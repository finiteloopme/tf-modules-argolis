output "instance_self_link" {
  description = "Self link for the instance"
  value       = module.compute_instance.instances_self_links
  sensitive   = true
}

output "instance_details" {
  description = "GCE instance details"
  value       = module.compute_instance.instances_details
  sensitive   = true
}
