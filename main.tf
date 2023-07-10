terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = ">=3.49.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "sysadmins-terraform"
    storage_account_name = "sysadminstfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

# configure the azure provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# create a resource group inside a subscription
resource "azurerm_resource_group" "srs01" {
  name     = "${var.rg_name}-${terraform.workspace}"
  location = var.rg_location
}

# create a virtual network for the inter-service connections
resource "azurerm_virtual_network" "srvn01" {
  name                = "${var.vn_name}-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.srs01.name
  location            = azurerm_resource_group.srs01.location
  address_space       = var.vn_address_space["${terraform.workspace}"]
}

# create a storage account
resource "azurerm_storage_account" "sa01" {
  name                     = "${var.storage_account_name}${terraform.workspace}"
  resource_group_name      = azurerm_resource_group.srs01.name
  location                 = azurerm_resource_group.srs01.location
  account_tier             = var.storage_account_tier
  account_replication_type = "LRS"
}

# create a service plan for function apps
resource "azurerm_service_plan" "sp01" {
  name                = "${var.service_plan_name}-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.srs01.name
  location            = azurerm_resource_group.srs01.location
  os_type             = "Linux"
  sku_name            = var.service_plan_tier
}

# create and configure an azure linux function app
# azure function apps are deprecated in azure provider 3.0
# and will be removed completetly in 4.0.
resource "azurerm_linux_function_app" "lfa01" {
  # select application name based on the active workspace
  name = "${var.function_app_01_name}-${terraform.workspace}"

  resource_group_name = azurerm_resource_group.srs01.name
  location            = azurerm_resource_group.srs01.location

  storage_account_name       = azurerm_storage_account.sa01.name
  storage_account_access_key = azurerm_storage_account.sa01.primary_access_key
  service_plan_id            = azurerm_service_plan.sp01.id

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }
}

# current config for key vault
data "azurerm_client_config" "current" {}

# create and configure a key vault
resource "azurerm_key_vault" "kv01" {
  name                        = "${var.key_vault_name}-${terraform.workspace}"
  location                    = azurerm_resource_group.srs01.location
  resource_group_name         = azurerm_resource_group.srs01.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.key_vault_retention_days
  purge_protection_enabled    = false

  sku_name = "standard" # keeping the costs down

  # configure access policies for the key vault  
  access_policy = [
    {
      application_id = data.azurerm_client_config.current.client_id
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id

      key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]

    certificate_permissions = [
      "Get",
    ]
    }
  ]
}

# create a key vault secret
data "azurerm_key_vault_secret" "kvs_hello" {
  name            = var.sysadmins_secret_name
  key_vault_id    = azurerm_key_vault.kv01.id
  #value           = var.sysadmins_secret_value
}

# check if the secret has been properly set
# output "secret_value" {
#   value     = data.azurerm_key_vault_secret.kvs_hello.value
#   sensitive = true
# }