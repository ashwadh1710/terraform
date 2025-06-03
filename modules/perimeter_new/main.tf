

data "google_projects" "available_projects" {
  filter = "lifecycleState:ACTIVE parent.id:${var.organization_id}"
}

locals {
  resources = distinct(concat(
    [for p in data.google_projects.available_projects.projects : "projects/${p.number}"]
  ))
}

resource "google_access_context_manager_service_perimeter" "anonymous" {
  name           = "accessPolicies/${var.policy_id}/servicePerimeters/${var.perimeter_name}"
  parent         = "accessPolicies/${var.policy_id}"
  title          = var.perimeter_name
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    resources = local.resources
    restricted_services = var.restricted_services
    vpc_accessible_services {
      enable_restriction = var.vpc_accessible_services != null ? var.vpc_accessible_services.enable_restriction : false
      allowed_services   = var.vpc_accessible_services != null ? var.vpc_accessible_services.allowed_services : []
    }

    dynamic "ingress_policies" {
      for_each = var.ingress_policies
      content {
        ingress_from {
          identity_type = ingress_policies.value.ingress_identity_type
          identities    = ingress_policies.value.identities
          sources {
            access_level = ingress_policies.value.access_level
            resources    = ingress_policies.value.ingress_from_resource
          }
        }
        ingress_to {
          resources = ingress_policies.value.ingress_to_resource
          dynamic "operations" {
            for_each = ingress_policies.value.method_selectors
            content {
              service_name = operations.value.service_name
              method_selectors {
                method = try(operations.value.method, "*")
                permission = try(operations.value.permissions, null)
              }
            }
          }
        }
      }
    }

    dynamic "egress_policies" {
      for_each = var.egress_policies
      content {
        egress_from {
          identity_type = egress_policies.value.egress_identity_type
          identities    = egress_policies.value.identities
          sources {
            access_level = egress_policies.value.access_level
            resources    = egress_policies.value.egress_from_resource
          }
        }
        egress_to {
          resources = concat(egress_policies.value.egress_to_resource,
            egress_policies.value.egress_to_external_resources)
          dynamic "operations" {
            for_each = egress_policies.value.method_selectors
            content {
              service_name = operations.value.service_name
              method_selectors {
                method = try(operations.value.method, "*")
                permission = try(operations.value.permissions, null)
              }
            }
          }
        }
      }
    }
  }
}







