output "windows_vm_public_ip" {
  value       = google_compute_instance.windows_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP for RDP access to Windows VM"
}

output "member1_linux_vm_ip" {
  value = google_compute_instance.member1_linux_vm.network_interface[0].network_ip
}

output "member2_linux_vm_ip" {
  value = google_compute_instance.member2_linux_vm.network_interface[0].network_ip
}

output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.http_lb_forwarding_rule.ip_address
}

output "autoscaler_status" {
  value = google_compute_autoscaler.member1_autoscaler.id
}