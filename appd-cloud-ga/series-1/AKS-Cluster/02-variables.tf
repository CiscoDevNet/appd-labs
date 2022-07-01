# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "terraform-aks"
}

# Azure AKS Environment Name
variable "environment" {
  type = string  
  description = "This variable defines the Environment"  
  default = "dev"
}


# AKS Input Variables

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default = "/Users/charleli/.ssh/aks-prod-sshkeys-terraform/aksdevkey.pub"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
}
