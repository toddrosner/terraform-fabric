terraform {
  backend "gcs" {
    credentials = "~/.gcp/terraform-fabric.json"
    bucket      = "terraform-fabric-tf-state"
    prefix      = "development/us-west1/storage/filestore/shared-storage"
  }
}

provider "google" {
  credentials = "${file("~/.gcp/terraform-fabric.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
