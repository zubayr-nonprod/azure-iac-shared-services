# variables.tf
# Input variables for the root module.

variable "environment" {
  description = "Deployment environment (e.g. staging, production)."
  type        = string
}
