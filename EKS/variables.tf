variable "region" {
  type        = string
  description = "AWS region to deploy resources"
  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-\\d)$", var.region))
    error_message = "Region must be in format like us-west-2 or ap-south-1."
  }
}
