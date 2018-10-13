variable "project" {
  type = "string"
}

variable "region" {
  default     = "us-west2"
  description = "The region for the deployment"
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
