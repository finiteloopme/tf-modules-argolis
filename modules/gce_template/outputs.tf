output "self_link" {
  description = "Self link for the instance"
  value       = module.instance_template.self_link
  sensitive   = true
}

output "name" {
  description = "GCE instance details"
  value       = module.instance_template.name
}

output "tags" {
  value       = module.instance_template.tags
}   
