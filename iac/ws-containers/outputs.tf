output "cluster_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "get_credentials_command" {
  description = "Run this to configure kubectl for the new cluster."
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.this.name} --name ${azurerm_kubernetes_cluster.this.name}"
}

output "oidc_issuer_url" {
  description = "Needed later if you set up workload identity (e.g. for Key Vault or Entra auth to Postgres)."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}
