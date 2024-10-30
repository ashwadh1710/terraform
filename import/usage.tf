variable "firewall_rules" {
  type    = list(string)
  default = ["rule-1", "rule-2", "rule-3", "rule-4", "rule-5", "rule-6", "rule-7", "rule-8", "rule-9", "rule-10"]
}



resource "google_compute_firewall" "firewall_rules" {
  for_each = toset(var.firewall_rules)

  name    = each.key
  # Add other configuration parameters here
}
