resource "google_filestore_instance" "instance" {
  name = "${var.name}"
  zone = "${var.zone}"
  tier = "${var.tier}"

  file_shares {
    capacity_gb = 1024
    name        = "fileshare"
  }

  networks {
    network = "terraform-fabric"
    modes   = ["MODE_IPV4"]
  }
}
