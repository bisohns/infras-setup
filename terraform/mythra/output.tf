output "gce_public_ip" {
  value       = google_compute_address.mythra_static_ip.address
  description = "IP of mythra instance"
}
