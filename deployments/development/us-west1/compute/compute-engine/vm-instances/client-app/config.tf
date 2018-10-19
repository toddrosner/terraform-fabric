terraform {
  backend "gcs" {
    credentials = "~/.gcp/terraform-fabric.json"
    bucket      = "terraform-fabric-tf-state"
    prefix      = "development/us-west1/compute/compute-engine/vm-instances/client-app"
  }
}

provider "google" {
  credentials = "${file("~/.gcp/terraform-fabric.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
