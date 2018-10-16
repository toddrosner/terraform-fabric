resource "google_filestore_instance" "instance" {
  name = "${var.name}"
  zone = "${var.zone}"
  tier = "${var.tier}"

  file_shares {
    capacity_gb = 2660
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
