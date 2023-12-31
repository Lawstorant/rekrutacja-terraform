variable "rg_name" {
  description = "Name of the resource group"
  type = string
}

variable "rg_location" {
  description = "Location of the resource group"
  type = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type = string
}

variable "storage_account_tier" {
  description = "Tier of the storage account"
  type = string
}

variable "service_plan_name" {
  description = "Name of the service_plan"
  type = string
}

variable "service_plan_tier" {
  description = "Name of the service_plan"
  type = string
}

variable "function_app_01_name" {
  description = "Name of the function app"
  type = string
}

variable "key_vault_name" {
  description = "Name of the key vault"
  type = string
}

variable "key_vault_retention_days" {
  description = "Days before unrecovable"
  type = number
}

variable "sysadmins_secret_name" {
  description = "Name of the hello-sysadmins secret"
  type = string
}

# set only in the cli!
# do not store secrets in repository
variable "sysadmins_secret_value" {
  description = "Value of the hello-sysadmins secret"
  type      = string
  sensitive = true
  default   = "unset"
}
