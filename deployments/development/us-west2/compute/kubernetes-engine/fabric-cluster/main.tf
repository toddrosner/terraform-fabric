resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  network            = "${var.network}"
  zone               = "${var.zone}"
  initial_node_count = "${var.initial_node_count}"

  additional_zones = "${var.additional_zones}"

  master_auth {
    username = "${var.master_auth_username}"
    password = "${var.master_auth_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      foo     = "bar"
      service = "test"
    }

    tags = "${var.tags}"
  }
}

resource "google_container_node_pool" "primary" {
  name       = "${var.node_pool_name}"
  zone       = "${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.node_count}"

  node_config {
    preemptible  = "${var.node_config_preemptible}"
    machine_type = "${var.node_config_machine_type}"

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }
}
