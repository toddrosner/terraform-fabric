variable "project" {
  type = "string"
}

variable "region" {
  default     = "us-west2"
  description = "The region for the deployment"
  type        = "string"
}

variable "environment" {
  default     = "dev"
  description = "The environment name"
  typ         = "string"
}

variable "name" {
  default     = "terraform-fabric"
  description = "The name for the network"
  type        = "string"
}

variable "auto_create_subnetworks" {
  default     = "true"
  description = "Automatically create subnetworks"
  type        = "string"
}

variable "routing_mode" {
  default     = "REGIONAL"
  description = "Dynamically route to region or to all regions in network"
  type        = "string"
}

variable "description" {
  default     = "VPC network for terraform-fabric project"
  description = "The description for the network"
  type        = "string"
}
