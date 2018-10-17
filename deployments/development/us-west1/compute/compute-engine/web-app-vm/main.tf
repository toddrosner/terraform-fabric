resource "google_compute_instance" "vm_instance" {
  name         = "${var.name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.boot_disk_image}"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config = {}
  }
}
