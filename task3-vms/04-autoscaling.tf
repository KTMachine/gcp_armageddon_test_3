resource "google_compute_health_check" "autoscaler_health_check" {
  name = "autoscaler-health-check-region2"
  project = var.invictus_project_id

  http_health_check {
    port = 80
    request_path = "/index.html"
  }

  check_interval_sec    = 5
  timeout_sec           = 5
  healthy_threshold     = 2
  unhealthy_threshold   = 3
}

resource "google_compute_instance_template" "linux_template" {
  name_prefix   = "linux-template-region2"
  machine_type  = var.linux_vm_configs["private_region2"].machine_type
  tags          = ["member2-linux-vm"]

  disk {
    source_image = var.linux_vm_configs["private_region2"].disk_image
  }

  network_interface {
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "member1_autoscaler" {
  name               = "member1-autoscaler"
  base_instance_name = "autoscaled-linux-vm"
  zone               = var.linux_vm_configs["private_region1"].zone
  target_size        = var.autoscaler_config.min_replicas

  version {
    instance_template = google_compute_instance_template.linux_template.id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autoscaler_health_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "member1_autoscaler" {
  name   = "member1-autoscaler"
  zone   = var.linux_vm_configs["private_region1"].zone
  target = google_compute_instance_group_manager.member1_autoscaler.id

  autoscaling_policy {
    max_replicas    = var.autoscaler_config.max_replicas
    min_replicas    = var.autoscaler_config.min_replicas
    cooldown_period = var.autoscaler_config.cooldown_period

    cpu_utilization {
      target = var.autoscaler_config.target_cpu_utilization
    }
  }
}