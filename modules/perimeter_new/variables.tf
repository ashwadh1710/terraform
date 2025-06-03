
variable "policy_id" {
  description = "The ID of the parent access policy"
  type        = string

}

variable "perimeter_name" {
  description = "The name of the perimeter"
  type        = string
  # default     = "test_perimeter"
}

variable "organization_id" {
  description = "organization id"
  type = string
}

variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions"
  type = list(string)
}

variable "vpc_accessible_services" {
  description = "Configuration for vpc accessible services"
  type = object({
    enable_restriction = bool
    allowed_services = list(string)
  })
  default = {
    enable_restriction = true
    allowed_services = []
  }
}

variable "ingress_policies" {
  description = "List of ingress policies to set for the perimeter"
  type = list(object({
    ingress_identity_type = string
    identities = list(string)
    access_level          = string
    ingress_from_resource = list(string)
    ingress_to_resource = list(string)
    method_selectors = list(object({
      service_name = string
      method = string
      permissions = optional(string)
    }))
  }))
  default = [
    {
      ingress_identity_type = "ANY_IDENTITY"
      identities = []
      access_level          = ""
      ingress_from_resource = []
      ingress_to_resource = []
      method_selectors = [
        {
          service_name = "storage.googleapis.com"
          method       = "*"
          permissions  = null
        }
      ]
    }
  ]
}

variable "egress_policies" {
  description = "List of egress policies to set for the perimeter"
  type = list(object({
    egress_identity_type = string
    identities = list(string)
    access_level         = string
    egress_from_resource = list(string)
    egress_to_resource = list(string)
    egress_to_external_resources = list(string)
    method_selectors = list(object({
      service_name = string
      method = string
      permissions = optional(string)
    }))
  }))
  default = [
    {
      egress_identity_type = "ANY_IDENTITY"
      identities = []
      access_level         = ""
      egress_from_resource = []
      egress_to_resource = []
      egress_to_external_resources = []
      method_selectors = [
        {
          service_name = "storage.googleapis.com"
          method       = "*"
          permissions  = null
        }
      ]
    }
  ]
}
