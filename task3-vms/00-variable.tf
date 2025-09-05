variable "invictus_project_id" {
  description = "The GCP project ID for the Invictus project"
  type        = string
  default     = "invictus-65"
}

variable "member1_project_id" {
  description = "The GCP project ID for Member 1"
  type        = string
  default     = "service-p1-462917"
}

variable "member2_project_id" {
  description = "The GCP project ID for Member 2"
  type        = string
  default     = "service-p2-462917"
}

variable "invictus_region" {
  description = "The GCP region for the Invictus project"
  type        = string
  default     = "us-central1"
}

variable "private_region1" {
  description = "The GCP region for the Private project"
  type        = string
  default     = "europe-west1"
}

variable "private_region2" {
  description = "The GCP region for the Private project"
  type        = string
  default     = "asia-southeast1"
}

variable "windows_vm_config" {
  description = "Configuration for Windows VMs"
  type = map(object({
    machine_type = string
    zone         = string
    disk_image   = string
  }))
  default = {
    invictus_region = {
      machine_type = "e2-standard-2"
      zone         = "us-central1-a"
      disk_image   = "projects/windows-cloud/global/images/family/windows-2019"
    }
  }
}

variable "linux_vm_configs" {
  description = "Configuration for Linux VMs"
  type = map(object({
    machine_type = string
    zone         = string
    disk_image   = string
    member_name  = string
    salary       = string
    theo_source  = string
    promo_url    = string
    bg_url       = string
  }))
  default = {
    private_region1 = {
      machine_type = "e2-standard-2"
      zone         = "europe-west1-b"
      disk_image   = "ubuntu-2204-jammy-v20230919"
      member_name  = "Kareem The Machine"
      salary       = "$1,140,000"
      theo_source  = "Lizzo"
      promo_url    = "https://upload.wikimedia.org/wikipedia/en/8/8a/Dune_Part_Two_poster.jpg"
      bg_url       = "https://images.unsplash.com/photo-1506744038136-46273834b3fb"
    },
    private_region2 = {
      machine_type = "e2-standard-2"
      zone         = "asia-southeast1-a"
      disk_image   = "ubuntu-2204-jammy-v20230919"
      member_name  = "Invictus Black"
      salary       = "$150,000"
      theo_source  = "Grande Chocolate Rabuda"
      promo_url    = "https://upload.wikimedia.org/wikipedia/en/6/6e/Breaking_Bad_title_card.png"
      bg_url       = "https://images.unsplash.com/photo-1465101046530-73398c7f28ca"
    }

  }
}

variable "autoscaler_config" {
  description = "Configuration for the autoscaler"
  type = object({
    min_replicas          = number
    max_replicas          = number
    cooldown_period       = number
    target_cpu_utilization = number
  })
  default = {
    min_replicas          = 2
    max_replicas          = 4
    cooldown_period       = 60
    target_cpu_utilization = 0.6
  }
}