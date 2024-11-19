output "firewall_name" {
  description = "The name of the created firewall rule"
  value       = google_compute_firewall.default.name
}

output "firewall_self_link" {
  description = "The self-link of the created firewall rule"
  value       = google_compute_firewall.default.self_link
}

output "firewall_network" {
  description = "The network to which the firewall rule is attached"
  value       = google_compute_firewall.default.network
}

output "firewall_priority" {
  description = "The priority of the created firewall rule"
  value       = google_compute_firewall.default.priority
}

output "firewall_direction" {
  description = "The direction of the firewall rule (INGRESS or EGRESS)"
  value       = google_compute_firewall.default.direction
}

output "firewall_allowed" {
  description = "Protocols and ports allowed by the firewall rule"
  value       = google_compute_firewall.default.allow
}

output "firewall_target_tags" {
  description = "The target tags associated with the firewall rule"
  value       = google_compute_firewall.default.target_tags
}

output "firewall_source_ranges" {
  description = "The source IP ranges allowed by the firewall rule"
  value       = google_compute_firewall.default.source_ranges
}
