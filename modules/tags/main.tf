# Define a variable for tag configuration
variable "google_tags" {
  type = map(object({
    short_name  = string
    description = string
    values      = list(object({
      short_name  = string
      description = string
    }))
  }))

  default = {
    environment = {
      short_name  = "environment"
      description = "Environment tags"
      values = [
        { short_name = "dev", description = "Development environment" },
        { short_name = "prod", description = "Production environment" },
        { short_name = "staging", description = "Staging environment" }
      ]
    }
    department = {
      short_name  = "costcenter"
      description = "costCenter tags"
      values = [
        { short_name = "solutions", description = "IT department" },
        { short_name = "corporate_sales", description = "Sales department" }
      ]
    }
  }
}

# Create Tag Keys
resource "google_tags_tag_key" "tag_key" {
  for_each = var.google_tags

  parent      = "projects/anonymous-442118"  # Replace with your organization ID
  short_name  = each.value.short_name
  description = each.value.description
}

# Flatten tag values with their parent keys
locals {
  tag_values = flatten([
    for key, config in var.google_tags : [
      for value in config.values : {
        parent      = google_tags_tag_key.tag_key[key].id
        short_name  = value.short_name
        description = value.description
      }
    ]
  ])
}

# Create Tag Values for each flattened value
resource "google_tags_tag_value" "tag_value" {
  for_each = { for i, tag in local.tag_values : i => tag }

  parent      = each.value.parent
  short_name  = each.value.short_name
  description = each.value.description
}


