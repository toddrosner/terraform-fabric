resource "google_container_cluster" "primary" {
  provider           = "google"
  name               = "${var.cluster_name}"
  network            = "${var.network}"
  zone               = "${var.zone}"
  additional_zones   = "${var.additional_zones}"
  min_master_version = "${var.min_master_version}"

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name       = "default-pool"
    version    = "${var.node_version}"
    node_count = 1
  }

  master_auth {
    username = "${var.master_auth_username}"
    password = "${var.master_auth_password}"
  }
}

/*
resource "google_container_node_pool" "endorser" {
  provider   = "google-beta"
  name       = "endorser"
  cluster    = "${google_container_cluster.primary.name}"
  zone       = "${var.zone}"
  version    = "${var.node_version}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      "node-role.kubernetes.io/kafka" = "endorser"
      "service" = "endorsing"
    }

    taint {
      key = "Ordering"
      value = "true"
      effect = "NO_SCHEDULE"
    }

    taint {
      key = "Kafka"
      value = "true"
      effect = "NO_SCHEDULE"
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

resource "google_container_node_pool" "orderer" {
  provider   = "google-beta"
  name       = "orderer"
  cluster    = "${google_container_cluster.primary.name}"
  zone       = "${var.zone}"
  version    = "${var.node_version}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      "node-role.kubernetes.io/kafka" = "orderer"
      "service" = "ordering"
    }

    taint {
      key = "Endorsing"
      value = "true"
      effect = "NO_SCHEDULE"
    }

    taint {
      key = "Kafka"
      value = "true"
      effect = "NO_SCHEDULE"
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
*/

resource "google_container_node_pool" "kafka" {
  provider   = "google-beta"
  name       = "kafka"
  cluster    = "${google_container_cluster.primary.name}"
  zone       = "${var.zone}"
  version    = "${var.node_version}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      "node-role.kubernetes.io/kafka" = "kafka"
      "service"                       = "kafka"
    }

    taint {
      key    = "Endorsing"
      value  = "true"
      effect = "NO_SCHEDULE"
    }

    taint {
      key    = "Ordering"
      value  = "true"
      effect = "NO_SCHEDULE"
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
