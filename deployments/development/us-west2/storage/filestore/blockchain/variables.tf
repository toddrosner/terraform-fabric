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
  type        = "string"
}

variable "name" {
  default     = "blockchain"
  description = "The NFS file server name"
  type        = "string"
}

variable "zone" {
  default     = "us-west2-a"
  description = "The zone for the NFS file server"
  type        = "string"
}

variable "tier" {
  default     = "STANDARD"
  description = "The tier of storage for the NFS file server"
  type        = "string"
}
