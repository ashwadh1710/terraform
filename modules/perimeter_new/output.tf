
output "perimeter_name" {
  description = "The name of the service perimeter"
  value       = google_access_context_manager_service_perimeter.anonymous.name
}

output "perimeter_resources" {
  description = "Resources in the service perimeter"
  value       = google_access_context_manager_service_perimeter.anonymous.status[0].resources
}

output "perimeter_restricted_services" {
  description = "Restricted services in the perimeter"
  value       = google_access_context_manager_service_perimeter.anonymous.status[0].restricted_services
}