$directories = @(
  "pre-deployment",
  "deployments/hub",
  "deployments/identity"
  "deployments/landing-zone",
)

$currentDirectory = Get-Location

foreach ($directory in $directories) {
  Write-Verbose "Deploying Terraform resources in $directory" -Verbose
  Set-Location $directory
  if ($directory -ne "pre-deployment") {
    $env:TF_VAR_app_configuration_store_id = $appConfigurationStoreId
    terraform init 
    terraform apply -auto-approve
  }
  else {
    terraform init 
    terraform apply -auto-approve
    $appConfigurationStoreId = terraform output app_configuration_store_id | convertFrom-Json
  }
  Set-Location $currentDirectory
}
