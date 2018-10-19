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

variable "name" {
  default     = "nfs-disk"
  description = "The name of the persistent disk"
  type        = "string"
}

variable "type" {
  default     = "pd-standard"
  description = "The type of persistent disk"
  type        = "string"
}

variable "zone" {
  default     = "us-west1-a"
  description = "The zone for the persistent disk"
  type        = "string"
}

variable "size" {
  default     = "10"
  description = "The persistent disk size in GB"
  type        = "string"
}
