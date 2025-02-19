terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "cidr_blocks" { default = ["10.0.0.0/16", "192.168.1.0/24"] }



locals {
  cidrs = jsondecode(file("${path.module}/cidr_blocks.json"))["cidrs"]
}

output "parsed_cidrs" {
  value = local.cidrs
}
