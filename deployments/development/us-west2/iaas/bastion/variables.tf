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

variable "name" {
  default     = "bastion"
  description = "The instance name"
  type        = "string"
}

variable "machine_type" {
  default     = "f1-micro"
  description = "The type of machine for the instance"
  type        = "string"
}

variable "zone" {
  default     = "us-west2-a"
  description = "The zone for the instance"
  type        = "string"
}

variable "boot_disk_image" {
  default     = "debian-cloud/debian-9"
  description = "The machine image"
  type        = "string"
}
