terraform {
  required_version = "1.6.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.88.0" # Update to the latest stable version compatible with 1.6.5
    }
  }
}
