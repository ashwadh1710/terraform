package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFirewallDeployment(t *testing.T) {
	// Define Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/ngfw", // Path to the Terraform configuration
		Vars: map[string]interface{}{
			"project_id": "anonymous",
			"region":     "us-central1",
		},
	}

	// Ensure resources are cleaned up after testing
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply the Terraform configuration
	terraform.InitAndApply(t, terraformOptions)

	// Test outputs
	firewallName := terraform.Output(t, terraformOptions, "firewall_name")
	assert.Equal(t, "firewall-test", firewallName, "Firewall name should be 'firewall-test'")

	firewallNetwork := terraform.Output(t, terraformOptions, "firewall_network")
	assert.Contains(t, firewallNetwork, "firewall-test-network", "Firewall should be associated with the correct network")

	firewallPriority := terraform.Output(t, terraformOptions, "firewall_priority")
	assert.Equal(t, "1000", firewallPriority, "Firewall priority should be 1000")

	firewallDirection := terraform.Output(t, terraformOptions, "firewall_direction")
	assert.Equal(t, "INGRESS", firewallDirection, "Firewall direction should be 'INGRESS'")

	firewallAllowed := terraform.OutputListOfObjects(t, terraformOptions, "firewall_allowed")
	assert.GreaterOrEqual(t, len(firewallAllowed), 1, "Firewall should have at least one allowed rule")

	firewallTargetTags := terraform.OutputList(t, terraformOptions, "firewall_target_tags")
	assert.Contains(t, firewallTargetTags, "allow-http-https-ssh", "Firewall should have the target tag 'allow-http-https-ssh'")

	firewallSourceRanges := terraform.OutputList(t, terraformOptions, "firewall_source_ranges")
	assert.Contains(t, firewallSourceRanges, "0.0.0.0/0", "Firewall should allow traffic from all IPs")
}
