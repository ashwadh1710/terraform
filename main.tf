terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}


locals {
  cidrs = jsondecode(file("${path.module}/cidr_blocks.json"))["cidrs"]
}

output "parsed_cidrs" {
  value = local.cidrs
}
