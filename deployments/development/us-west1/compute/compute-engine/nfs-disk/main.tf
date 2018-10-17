resource "google_compute_disk" "default" {
  name  = "${var.name}"
  type  = "${var.type}"
  zone  = "${var.zone}"
  size  = "${var.size}"

  labels {
    environment = "${var.environment}"
  }
}
