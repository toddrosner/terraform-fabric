resource "google_compute_network" "default" {
  name                    = "${var.name}"
  auto_create_subnetworks = "${var.auto_create_subnetworks}"
  routing_mode            = "${var.routing_mode}"
  description             = "${var.description}"
}
