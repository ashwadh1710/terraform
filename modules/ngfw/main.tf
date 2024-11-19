

resource "google_compute_network" "default" {
  name = "firewall-test-network"
}

resource "google_compute_firewall" "default" {
  name    = "firewall-test"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  target_tags = ["allow-http-https-ssh"]

  source_ranges = ["0.0.0.0/0"] # Allow traffic from all IPs
  direction     = "INGRESS"
  priority      = 1000
}
