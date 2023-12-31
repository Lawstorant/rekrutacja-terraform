rg_name     = "rg-secretreader"
rg_location = "West Europe"

storage_account_name = "srstorage01"
storage_account_tier = "Standard"

service_plan_name    = "sp-secretreader-01"
service_plan_tier    = "Y1" # consumption sku
function_app_01_name = "sysadmins-secretreader"

key_vault_name = "kv-secretreader-01"
key_vault_retention_days = 14

sysadmins_secret_name = "hello-sysadmins"

# Only doing this to show the purpose of the task.
# Secret values should be securely stored in some kind of
# a library and passed to the terraform during terrafrom
# operations such as plan or apply
# terraform apply -var=`sysadmins_secret_value="Hello SysAdmins!"`
sysadmins_secret_value = "Hello SysAdmins!"
