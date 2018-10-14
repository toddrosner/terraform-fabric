resource "google_container_cluster" "primary" {
  name                     = "${var.cluster_name}"
  network                  = "${var.network}"
  zone                     = "${var.zone}"
  additional_zones         = "${var.additional_zones}"
  remove_default_node_pool = true

  node_pool {
    name = "default-pool"
  }

  master_auth {
    username = "${var.master_auth_username}"
    password = "${var.master_auth_password}"
  }
}

resource "google_container_node_pool" "endorsers" {
  name       = "endorsers"
  zone       = "${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.node_count}"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      service = "endorsing"
    }

    tags = "${var.tags}"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
}

resource "google_container_node_pool" "orderers" {
  name       = "orderers"
  zone       = "${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.node_count}"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      service = "ordering"
    }

    tags = "${var.tags}"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
}
