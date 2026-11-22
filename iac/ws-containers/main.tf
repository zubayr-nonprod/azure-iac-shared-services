# main.tf
# Root module composition. Wire up child modules and resources here.

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.name_prefix}-${local.environment}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = var.name_prefix
  kubernetes_version  = var.kubernetes_version

  # Free control plane: no SLA, fine for dev/test.
  sku_tier = "Free"

  # Keep patch versions and node images current without manual work.
  automatic_upgrade_channel = "patch"
  node_os_upgrade_channel   = "NodeImage"

  # Free, and useful later for giving pods Azure access without secrets.
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Regular (on-demand) system pool. AKS requires one: spot pools cannot be
  # the system pool. Leave it untainted so workloads can fall back onto it
  # if spot capacity disappears.
  default_node_pool {
    name                        = "system"
    vm_size                     = var.system_vm_size
    node_count                  = 1
    os_disk_size_gb             = var.os_disk_size_gb
    os_disk_type                = "Managed"
    temporary_name_for_rotation = "systemtmp"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  # Azure CNI Overlay: AKS creates and manages the VNet, no extra networking
  # resources to pay for or maintain. Standard LB is the only supported SKU.
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
  }

  dynamic "api_server_access_profile" {
    for_each = length(var.authorized_ip_ranges) > 0 ? [1] : []
    content {
      authorized_ip_ranges = var.authorized_ip_ranges
    }
  }

  # Deliberately NOT enabling: oms_agent (Log Analytics / Container Insights),
  # Defender, Azure Policy, or private cluster. All add cost or complexity.

  tags = local.common_tags
}

# Spot user pool for Backstage. Spot nodes can be evicted with ~30 seconds'
# notice, so run stateless workloads (Backstage keeps its state in Postgres).
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  mode                  = "User"
  vm_size               = var.spot_vm_size

  # priority and eviction_policy cannot be changed after creation.
  priority        = "Spot"
  eviction_policy = "Delete"
  spot_max_price  = -1 # pay up to the on-demand price; never evicted for price

  # Autoscaler replaces evicted nodes and can scale the pool to zero.
  auto_scaling_enabled = true
  min_count            = var.spot_min_count
  max_count            = var.spot_max_count

  os_disk_size_gb = var.os_disk_size_gb
  os_disk_type    = "Managed"

  # AKS adds this taint to spot pools automatically. Pods need a matching
  # toleration (see backstage-spot-scheduling.yaml).
  node_taints = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]

  tags = local.common_tags

  lifecycle {
    # The autoscaler owns the node count.
    ignore_changes = [node_count]
  }
}
