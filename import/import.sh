# Replace these with the actual rule names you need to import
rule_names=("rule-1" "rule-2" "rule-3" "rule-4" "rule-5" "rule-6" "rule-7" "rule-8" "rule-9" "rule-10")

for rule in "${rule_names[@]}"; do
  terraform import google_compute_firewall.$rule YOUR_PROJECT_ID/$rule
done
