terraform {
  backend "gcs" {
    credentials = "~/.gcp/terraform-fabric.json"
    bucket      = "terraform-fabric-tf-state"
    prefix      = "development/us-west1/compute/kubernetes-engine/clusters/fabric"
  }
}

provider "google" {
  credentials = "${file("~/.gcp/terraform-fabric.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

provider "google-beta" {
  credentials = "${file("~/.gcp/terraform-fabric.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
