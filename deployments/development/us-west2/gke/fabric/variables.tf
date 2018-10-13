variable "project" {
  default     = "terraform-fabric"
  description = "The name of the project"
  type        = "string"
}

variable "region" {
  default     = "us-west2"
  description = "The region for the deployment"
  type        = "string"
}
