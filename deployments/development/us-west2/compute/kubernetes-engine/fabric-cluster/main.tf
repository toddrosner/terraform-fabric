resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  network            = "${var.network}"
  zone               = "${var.zone}"
  additional_zones   = "${var.additional_zones}"

  lifecycle {
    ignore_changes = ["node_pool"]
  }

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
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

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
    max_node_count = 1
  }
}

/*
resource "google_container_node_pool" "orderers" {
  name       = "orderers"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

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
    max_node_count = 1
  }
}

resource "google_container_node_pool" "kafka" {
  name       = "kafka"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      service = "channels"
    }

    tags = "${var.tags}"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }
}
*/
