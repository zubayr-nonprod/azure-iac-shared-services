variable "subscription_id" {
  description = "Azure subscription ID to deploy into."
  type        = string
  default     = "d4e23489-0053-44b0-b6f5-efe3ab94b305"
}

# variable "location" {
#   description = "Azure region. Prices and spot capacity vary by region, so choose deliberately and confirm your VM sizes are available there."
#   type        = string
# }

variable "name_prefix" {
  description = "Prefix used for resource names (letters, digits and hyphens; keep it short)."
  type        = string
  default     = "ss"
}

variable "kubernetes_version" {
  description = "Kubernetes version (e.g. \"1.33\"). Leave null to use the AKS default for the region."
  type        = string
  default     = null
}

variable "system_vm_size" {
  description = "VM size for the single on-demand system node. System pools need >= 2 vCPU / 4 GB and AKS does not support B-series here."
  type        = string
  default     = "Standard_D2as_v5"
}

variable "spot_vm_size" {
  description = "VM size for the spot user node pool that runs Backstage."
  type        = string
  default     = "Standard_D2as_v5"
}

variable "spot_min_count" {
  description = "Minimum spot nodes. 0 lets the pool scale to zero when nothing is scheduled on it."
  type        = number
  default     = 0
}

variable "spot_max_count" {
  description = "Maximum spot nodes."
  type        = number
  default     = 2
}

variable "os_disk_size_gb" {
  description = "OS disk size per node. AKS defaults to 128 GB, which costs noticeably more; 32 GB is enough for a lab."
  type        = number
  default     = 32
}

variable "authorized_ip_ranges" {
  description = "Optional CIDRs allowed to reach the public API server (e.g. [\"203.0.113.4/32\"]). Empty list leaves it open to the internet."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    environment = "dev"
    workload    = "backstage"
  }
}
