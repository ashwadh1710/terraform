
module "anonymous" {
  source = "../modules/perimeter_new"
  organization_id = ""
  perimeter_name = ""
  policy_id = ""
  restricted_services = []
  vpc_accessible_services = {
    enable_restriction = true
    allowed_services = ["storage.googleapis.com"]
  }
  ingress_policies = [
      {
        ingress_identity_type = "IDENTITY_TYPE_UNSPECIFIED"
        identities = ["user:admin@example.com"]
        access_level          = "accessPolicies/12345678/accessLevels/my_access_level"
        ingress_from_resource = ["projects/123456"]
        ingress_to_resource = ["projects/123456"]
        method_selectors = [
          {
            service_name = []
            method      = "*"
            permissions = null
          }
        ]
      },
    {
      ingress_identity_type = "IDENTITY_TYPE_UNSPECIFIED"
      identities = ["user:admin@example.com"]
      access_level          = "accessPolicies/12345678/accessLevels/my_access_level"
      ingress_from_resource = ["projects/123456"]
      ingress_to_resource = ["projects/123456"]
      ingress_service_name  = "storage.googleapis.com"
      method_selectors = [
        {
          method      = "*"
          permissions = null
        }
      ]
    }
    ]
  egress_policies = [
      {
        egress_identity_type = "IDENTITY_TYPE_UNSPECIFIED"
        identities = ["user:admin@example.com"]
        access_level         = "accessPolicies/12345678/accessLevels/my_access_level"
        egress_from_resource = ["projects/123456"]
        egress_to_resource = ["projects/123456"]
        egress_to_external_resources = ["storage.googleapis.com"]
        egress_service_name  = "storage.googleapis.com"
        method_selectors = [
          {
            method      = "*"
            permissions = null
          }
        ]
      }
    ]
}

