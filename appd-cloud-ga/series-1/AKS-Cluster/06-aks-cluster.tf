# Provision AKS Cluster
/*
1. Add Basic Cluster Settings
  - Get Latest Kubernetes Version from datasource (kubernetes_version)
  - Add Node Resource Group (node_resource_group)
2. Add Default Node Pool Settings
  - orchestrator_version (latest kubernetes version using datasource)
  - availability_zones
  - enable_auto_scaling
  - max_count, min_count
  - os_disk_size_gb
  - type
  - node_labels
  - tags
5. RBAC & Azure AD Integration
6. Admin Profiles
  - Linux Profile
7. Network Profile
8. Cluster Tags  
9. Update local azure and kubectl credentials for the newly created cluster
*/

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"
  azure_policy_enabled= true

  default_node_pool {
    name                 = "systempool"
    vm_size              = "standard_a4_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 4
    min_count            = 2
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
    } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
   } 
  }

# Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

# RBAC and Azure AD Integration Block
  # azure_active_directory_role_based_access_control {
  #   managed = true
  #   admin_group_object_ids = [azuread_group.aks_administrators.id]
  #   azure_rbac_enabled = true
  # }


# Linux Profile
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

# Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }

  tags = {
    Environment = "dev"
  }
}

resource "time_sleep" "wait_for_kube" {
  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
  # GKE master endpoint may not be immediately accessible, resulting in error, waiting does the trick
  create_duration = "30s"
}

resource "null_resource" "local_k8s_context" {
  depends_on = [time_sleep.wait_for_kube]
  provisioner "local-exec" {
    # Update your local azure and kubectl credentials for the newly created cluster
    command = "for i in 1 2 3 4 5; do az aks get-credentials --overwrite-existing --resource-group ${var.resource_group_name}-${var.environment} --name ${azurerm_kubernetes_cluster.aks_cluster.name} --admin && break || sleep 60; done"
  }
}
