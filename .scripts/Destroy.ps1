$directories = @(
  "deployments/landing-zone",
  "deployments/identity",
  "deployments/hub",
  "pre-deployment"
)

$currentDirectory = Get-Location

Set-Location "pre-deployment"
terraform init
$appConfigurationStoreId = terraform output app_configuration_store_id | convertFrom-Json
Set-Location $currentDirectory

foreach ($directory in $directories) {
  Write-Verbose "Destroying Terraform resources in $directory" -Verbose
  Set-Location $directory
  terraform init 
  terraform destroy -auto-approve
  Set-Location $currentDirectory
}