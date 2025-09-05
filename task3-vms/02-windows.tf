resource "google_compute_instance" "windows_vm" {
  name         = "invictus-windows-wm"
  machine_type = var.windows_vm_config["invictus_region"].machine_type
  zone         = var.windows_vm_config["invictus_region"].zone

  boot_disk {
    initialize_params {
      image = var.windows_vm_config["invictus_region"].disk_image
    }
  }

  network_interface {
    network    = google_compute_network.main_vpc.id
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {}
  }
}