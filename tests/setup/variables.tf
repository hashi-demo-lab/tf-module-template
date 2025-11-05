############################################################################################################
# Test Setup Variables
############################################################################################################

variable "location" {
  type        = string
  description = "Azure region for test resources"
  default     = "eastus"  # Use low-cost region for testing
}

# Add additional variables as needed for your test fixtures
