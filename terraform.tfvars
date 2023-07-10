client_id       = "f637a7aa-4460-4846-a6c6-1b7a8c60de03"
tenant_id       = "da07669b-f847-41ae-97fb-5b5071ad9647"
subscription_id = "0122c68d-1f58-4cff-a00d-c2847b621dd2"

rg_name     = "rg-secretreader-shared-01"
rg_location = "West Europe"

vn_name          = "vn-secretreader-01"
vn_address_space = ["10.0.0.0/24"]

storage_account_name = "secretreader-sa-01"
storage_account_tier = "Standard"

service_plan_name    = "sp-secretreader-01"
service_plan_tier    = "Y1" # consumption sku
function_app_01_names = {
    prod = "sysadmins-secretreader",
    dev = "sysadmins-secretreader-dev"
}

key_vault_name = "kv-secretreader-01"
key_vault_retention_days = 14

sysadmins_secret_name       = "hello-sysadmins"
sysadmins_secret_expiration = "2024-07-10T22:00:00Z"

# Only doing this to show the purpose of the task.
# Secret values should be securely stored in some kind of
# a library and passed to the terraform during terrafrom
# operations such as plan or apply
sysadmins_secret_value = "Hello SysAdmins!"