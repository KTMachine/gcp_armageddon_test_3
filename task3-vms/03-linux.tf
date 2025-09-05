# Compute Instance for Private Region 1
resource "google_compute_instance" "member1_linux_vm" {
  name         = "member1-linux-vm"
  machine_type = var.linux_vm_configs["private_region1"].machine_type
  zone         = var.linux_vm_configs["private_region1"].zone
  tags         = ["member1-linux-vm"]

  boot_disk {
    initialize_params {
      image = var.linux_vm_configs["private_region1"].disk_image
    }
  }

  network_interface {
    network    = google_compute_network.main_vpc.id
    subnetwork = google_compute_subnetwork.private_subnet1.id
  }

  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y apache2
      systemctl start apache2
      systemctl enable apache2
      echo "<h1 style='font-family:Comic Sans MS;position:absolute;top:0;left:0;'>Resource Info: $(hostname)</h1>" > /var/www/html/index.html
      echo "<p>I, ${var.linux_vm_configs["private_region1"].member_name}, will make ${var.linux_vm_configs["private_region1"].salary} per year thanks to Theo and ${var.linux_vm_configs["private_region1"].theo_source}!</p>" >> /var/www/html/index.html
      # Add background and promo images as needed
    EOF
  }
}

# Compute Instance for Private Region 2
resource "google_compute_instance" "member2_linux_vm" {
  name         = "member2-linux-vm"
  machine_type = var.linux_vm_configs["private_region2"].machine_type
  zone         = var.linux_vm_configs["private_region2"].zone
  tags         = ["member2-linux-vm"]

  boot_disk {
    initialize_params {
      image = var.linux_vm_configs["private_region2"].disk_image
    }
  }

  network_interface {
    network    = google_compute_network.main_vpc.id
    subnetwork = google_compute_subnetwork.private_subnet2.id
  }

  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y apache2
      systemctl start apache2
      systemctl enable apache2
      echo "<h1 style='font-family:Comic Sans MS;position:absolute;top:0;left:0;'>Resource Info: $(hostname)</h1>" > /var/www/html/index.html
      echo "<p>I, ${var.linux_vm_configs["private_region2"].member_name}, will make ${var.linux_vm_configs["private_region2"].salary} per year thanks to Theo and ${var.linux_vm_configs["private_region2"].theo_source}!</p>" >> /var/www/html/index.html
      # Add background and promo images as needed
    EOF
  }
}