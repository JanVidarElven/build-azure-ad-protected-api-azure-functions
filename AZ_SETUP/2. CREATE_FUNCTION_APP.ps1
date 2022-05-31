# Az PowerShell Commands for Creating Azure Function App
# Building on file 1.CREATE_DATABASE.ps1

# Get Resource Group
$rg = Get-AzResourceGroup -Name "rg-demoazureadprotected-api"

# Environment specific variables to be used for global resource names
$yourOrg = "elven"
$yourLocation = "Norway East"

# Create if needed a General Purpose Storage Account for Function App
If (Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName | Where-Object {$_.StorageAccountName -eq $yourOrg+"saprotectedapi"} ) {
    $storageAcct = Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName -Name $yourOrg"saprotectedapi"
}
else {
    $storageAcct = New-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName -Name $yourOrg"saprotectedapi" -Location $yourLocation -SkuName Standard_LRS
}

# Create a dedicated Application Insights instance for use in Function App monitoring
$appi = New-AzApplicationInsights -Kind web -ResourceGroupName $rg.ResourceGroupName -Name "appi-$yourOrg-protectedapi" -location $yourLocation

# Create Consumption Function App based on PowerShell Core and default version and runtime
New-AzFunctionApp -Name "$yourOrg-fa-protected-api" `
-ResourceGroupName $rg.ResourceGroupName `
-Location "Norway East" `
-StorageAccountName $storageAcct.StorageAccountName `
-Runtime PowerShell `
-ApplicationInsightsName $appi.Name `
-ApplicationInsightsKey $appi.InstrumentationKey `
-IdentityType SystemAssigned

