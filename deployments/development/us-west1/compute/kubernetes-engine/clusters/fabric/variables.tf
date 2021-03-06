variable "project" {
  type = "string"
}

variable "region" {
  default     = "us-west1"
  description = "The region for the deployment"
  type        = "string"
}

variable "environment" {
  default     = "dev"
  description = "The environment name"
  type        = "string"
}

variable "cluster_name" {
  default     = "hyperledger-fabric"
  description = "The name of the cluster"
  type        = "string"
}

variable "zone" {
  default     = "us-west1-a"
  description = "The zone for the cluster"
  type        = "string"
}

variable "additional_zones" {
  default     = ["us-west1-b", "us-west1-c"]
  description = "Additional zones for the cluster"
  type        = "list"
}

variable "network" {
  default     = "terraform-fabric"
  description = "The name of the network"
  type        = "string"
}

variable "min_master_version" {
  default     = "1.10.7-gke.6"
  description = "The minimum master version"
  type        = "string"
}

variable "master_auth_username" {
  default     = "y0da"
  description = "The GKE username"
  type        = "string"
}

variable "master_auth_password" {
  default     = "CDk3qgqqwyOQCaok"
  description = "The GKE password"
  type        = "string"
}

variable "tags" {
  default     = ["development", "fabric"]
  description = "The tags for the cluster nodes"
  type        = "list"
}

variable "node_version" {
  default     = "1.10.7-gke.6"
  description = "The node version"
  type        = "string"
}

variable "node_config_preemptible" {
  default     = "true"
  description = "Preembtible status of the node pool nodes"
  type        = "string"
}

variable "node_config_machine_type" {
  default     = "n1-standard-1"
  description = "The machine type of the node pool nodes"
  type        = "string"
}
