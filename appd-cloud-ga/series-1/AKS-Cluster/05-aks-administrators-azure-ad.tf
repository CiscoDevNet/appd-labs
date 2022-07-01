# # Create Azure AD Group in Active Directory for AKS Admins
# resource "azuread_group" "aks_administrators" {
#   display_name = "${azurerm_resource_group.aks_rg.name}-cluster-administrators"
#   description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-cluster."
# }

# Get current user object
data "azurerm_client_config" "current" {
}
# data "azuread_user" "current" {
#   object_id = data.azurerm_client_config.current.client_id
# }


