resource "google_compute_health_check" "invictus_lb_health_check" {
  name    = "invictus-lb-health-check"
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

resource "google_compute_backend_service" "global_linux_backend" {
  name          = "global-linux-backend-service"
  project       = var.invictus_project_id
  protocol      = "HTTP"
  health_checks = [google_compute_health_check.invictus_lb_health_check.id]

  backend {
    group          = google_compute_instance_group_manager.member1_autoscaler.instance_group
    balancing_mode = "UTILIZATION"
  }
}

resource "google_compute_url_map" "http_lb_url_map" {
  name    = "http-lb-url-map"
  project = var.invictus_project_id
  default_service = google_compute_backend_service.global_linux_backend.id
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name    = "http-lb-proxy"
  project = var.invictus_project_id
  url_map = google_compute_url_map.http_lb_url_map.id
}

resource "google_compute_global_forwarding_rule" "http_lb_forwarding_rule" {
  name       = "http-lb-forwarding-rule"
  project    = var.invictus_project_id
  ip_protocol = "TCP"
  port_range = "80"
  target     = google_compute_target_http_proxy.http_lb_proxy.id
}