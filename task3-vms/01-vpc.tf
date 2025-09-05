# Main VPC
resource "google_compute_network" "main_vpc" {
  name                    = "multi-region-vpc"
  auto_create_subnetworks = false
}

# Subnetwork for Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.22.11.0/24"
  network       = google_compute_network.main_vpc.id
  region        = var.invictus_region
}

# Subnetwork for Private Subnetwork 1
resource "google_compute_subnetwork" "private_subnet1" {
  name          = "private-subnet1"
  ip_cidr_range = "10.22.22.0/24"
  network       = google_compute_network.main_vpc.id
  region        = var.private_region1
}

# Subnetwork for Private Subnetwork 2
resource "google_compute_subnetwork" "private_subnet2" {
  name          = "private-subnet2"
  ip_cidr_range = "10.22.33.0/24"
  network       = google_compute_network.main_vpc.id
  region        = var.private_region2
}

# Cloud Router for the first Private Subnetwork
resource "google_compute_router" "private_router1" {
  region  = var.private_region1
  name    = "private-router1"
  network = google_compute_network.main_vpc.id
}

# Cloud Router for the second Private Subnetwork
resource "google_compute_router" "private_router2" {
  region  = var.private_region2
  name    = "private-router2"
  network = google_compute_network.main_vpc.id
}

# NAT's for Private Subnetwork 1
resource "google_compute_router_nat" "private_nat1" {
  name = "private-nat1"
  router = google_compute_router.private_router1.name
  region = var.private_region1
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.private_subnet1.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# NAT's for Private Subnetwork 2
resource "google_compute_router_nat" "private_nat2" {
  name = "private-nat2"
  router = google_compute_router.private_router2.name
  region = var.private_region2
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.private_subnet2.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# First Firewall Rule
resource "google_compute_firewall" "rdp_windows" {
  name    = "allow-rdp-windows"
  network = google_compute_network.main_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags   = ["windows-vm"]
  source_ranges = ["0.0.0.0/0"]
}

# Second Firewall Rule
resource "google_compute_firewall" "ssh_linux" {
  name    = "allow-ssh-linux"
  network = google_compute_network.main_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["member1-linux-vm", "member2-linux-vm"]
  source_ranges = ["0.0.0.0/0"]
}

# Third Firewall Rule
resource "google_compute_firewall" "internal_access" {
  name    = "allow-internal-access"
  network = google_compute_network.main_vpc.id

  allow {
    protocol = "tcp"
    ports = ["80", "443", "3389", "22"]
  }

  target_tags = ["member1-linux-vm", "member2-linux-vm"]
  source_tags = ["windows-vm"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.main_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["member1-linux-vm", "member2-linux-vm", "windows-vm"]
  source_ranges = ["0.0.0.0/0"]
}