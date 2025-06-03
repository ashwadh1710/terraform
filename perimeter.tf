resource "google_access_context_manager_service_perimeter" "default" {
  name           = "accessPolicies/${var.access_policy_id}/servicePerimeters/${var.perimeter_name}"
  parent         = "accessPolicies/${var.access_policy_id}"
  perimeter_type = var.perimeter_type
  title          = var.title
  description    = var.description
  use_explicit_dry_run_spec = var.use_explicit_dry_run_spec

  status {
    resources           = var.status_resources
    access_levels       = var.status_access_levels
    restricted_services = var.status_restricted_services

    dynamic "vpc_accessible_services" {
      for_each = var.status_vpc_accessible_services != null ? [1] : []
      content {
        enable_restriction = var.status_vpc_accessible_services.enable_restriction
        allowed_services   = var.status_vpc_accessible_services.allowed_services
      }
    }

    egress_policies = [
      for p in var.egress_policies : {
        egress_from = p.egress_from
        egress_to   = p.egress_to
      }
    ]

    ingress_policies = [
      for p in var.ingress_policies : {
        ingress_from = p.ingress_from
        ingress_to   = p.ingress_to
      }
    ]
  }
}


variable "access_policy_id" { type = string }
variable "perimeter_name" { type = string }
variable "perimeter_type" { type = string default = "PERIMETER_TYPE_REGULAR" }
variable "title" { type = string }
variable "description" { type = string default = "" }
variable "use_explicit_dry_run_spec" { type = bool default = false }

variable "status_resources" { type = list(string) default = [] }
variable "status_access_levels" { type = list(string) default = [] }
variable "status_restricted_services" { type = list(string) default = [] }

variable "status_vpc_accessible_services" {
  type = object({
    enable_restriction = bool
    allowed_services   = list(string)
  })
  default = null
}

variable "egress_policies" {
  type = list(object({
    title       = string
    description = optional(string)
    egress_from = object({
      identities    = optional(list(string))
      identity_type = optional(string)
    })
    egress_to = object({
      resources = optional(list(string))
      operations = optional(list(object({
        service_name     = string
        method_selectors = optional(list(object({
          method     = optional(string)
          permission = optional(string)
        })))
      })))
    })
  }))
  default = []
}

variable "ingress_policies" {
  type = list(object({
    title       = string
    description = optional(string)
    ingress_from = object({
      identities    = optional(list(string))
      identity_type = optional(string)
      sources = optional(list(object({
        access_level = optional(string)
        resource     = optional(string)
      })))
    })
    ingress_to = object({
      resources = optional(list(string))
      operations = optional(list(object({
        service_name     = string
        method_selectors = optional(list(object({
          method     = optional(string)
          permission = optional(string)
        })))
      })))
    })
  }))
  default = []
}


module "perimeter" {
  source                      = "./modules/perimeter"
  access_policy_id            = var.access_policy_id
  perimeter_name              = var.perimeter_name
  perimeter_type              = var.perimeter_type
  title                       = var.title
  description                 = var.description
  use_explicit_dry_run_spec   = var.use_explicit_dry_run_spec
  status_resources            = var.status_resources
  status_access_levels        = var.status_access_levels
  status_restricted_services  = var.status_restricted_services
  status_vpc_accessible_services = var.status_vpc_accessible_services
  ingress_policies            = var.ingress_policies
  egress_policies             = var.egress_policies
}


variable "access_policy_id" { type = string }
variable "perimeter_name" { type = string }
variable "perimeter_type" { type = string default = "PERIMETER_TYPE_REGULAR" }
variable "title" { type = string }
variable "description" { type = string default = "" }
variable "use_explicit_dry_run_spec" { type = bool default = false }

variable "status_resources" { type = list(string) default = [] }
variable "status_access_levels" { type = list(string) default = [] }
variable "status_restricted_services" { type = list(string) default = [] }

variable "status_vpc_accessible_services" {
  type = object({
    enable_restriction = bool
    allowed_services   = list(string)
  })
  default = null
}

variable "egress_policies" { type = list(any) default = [] }
variable "ingress_policies" { type = list(any) default = [] }



access_policy_id = "123456789"
perimeter_name   = "secure-zone"
title            = "Secure Perimeter"
description      = "Protect sensitive access"
use_explicit_dry_run_spec = true

status_resources = ["projects/secure-project"]

status_access_levels = [
  "accessPolicies/123456789/accessLevels/dev"
]

status_restricted_services = [
  "storage.googleapis.com",
  "bigquery.googleapis.com"
]

status_vpc_accessible_services = {
  enable_restriction = true
  allowed_services   = ["bigquery.googleapis.com"]
}

egress_policies = [
  {
    title = "Allow GCS Writes"
    egress_from = {
      identities    = ["user:writer@example.com"]
      identity_type = "IDENTITY_TYPE_USER_ACCOUNT"
    }
    egress_to = {
      resources = ["projects/target-project"]
      operations = [
        {
          service_name = "storage.googleapis.com"
          method_selectors = [
            { method = "storage.objects.create" }
          ]
        }
      ]
    }
  }
]

ingress_policies = [
  {
    title = "Allow BigQuery Access"
    ingress_from = {
      identities    = ["user:reader@example.com"]
      identity_type = "IDENTITY_TYPE_USER_ACCOUNT"
      sources = [
        {
          access_level = "accessPolicies/123456789/accessLevels/dev"
          resource     = "projects/123456789"
        }
      ]
    }
    ingress_to = {
      resources = ["projects/secure-project"]
      operations = [
        {
          service_name = "bigquery.googleapis.com"
          method_selectors = [
            { method = "ReadRows" }
          ]
        }
      ]
    }
  }
]
