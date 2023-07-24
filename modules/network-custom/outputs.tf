output "subnets" {
    value = module.custom-subnets.subnets
    depends_on = [
      module.custom-subnets
    ]
}

output "network" {
    value = module.custom-network.network_self_link
    sensitive = true
    depends_on = [
      module.custom-network
    ]
}

output "network_name" {
  value = module.custom-network.network_name
}

