variable "project_id" {
  description = "ID for the project"
}
variable "network_name" {
  description = "Name of the network"
  type        = string
}
variable "subnets" {
  description = "Array of subnets to be created"
  type        = list(map(string))
}
variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}
