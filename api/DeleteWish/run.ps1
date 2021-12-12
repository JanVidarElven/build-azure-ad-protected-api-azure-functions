using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $CosmosInput)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request to delete a whish."

# Check id and get item to delete
If ($Request.Params.id) {
    $whish = $CosmosInput | Where-Object { $_.id -eq $Request.Params.id}
}
else {
    
}

# Build the Document Uri for Cosmos DB REST API
$cosmosConnection = $env:Festive_CosmosDB -replace ';',"`r`n" | ConvertFrom-StringData
$documentUri = $cosmosConnection.AccountEndpoint + "dbs/" + "festivetechcalendar" + "/colls/" + "whishes" + "/docs/" + $whish.id

# Check if running with MSI (in Azure) or Interactive User (local VS Code)
If ($env:MSI_SECRET) {
    
    # Get Managed Service Identity from Function App Environment Settings
    $msiEndpoint = $env:MSI_ENDPOINT
    $msiSecret = $env:MSI_SECRET

    # Specify URI and Token AuthN Request Parameters
    $apiVersion = "2017-09-01"
    $resourceUri = "https://cosmos.azure.com"
    $tokenAuthUri = $msiEndpoint + "?resource=$resourceUri&api-version=$apiVersion"

    # Authenticate with MSI and get Token
    $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$msiSecret"} -Uri $tokenAuthUri
    $bearerToken = $tokenResponse.access_token
    Write-Host "Successfully retrieved Access Token Cosmos Document DB API using MSI."

} else {
    # Get Access Token for the interactively logged on user in local VS Code
    $accessToken = Get-AzAccessToken -TenantId elven.onmicrosoft.com -ResourceUrl "https://cosmos.azure.com"
    $bearerToken = $accessToken.Token
}

# Prepare the API request to delete the document item
$partitionKey = $whish.id
$headers = @{
    'Authorization' = 'type=aad&ver=1.0&sig='+$bearerToken
    'x-ms-version' = '2018-12-31'
    'x-ms-documentdb-partitionkey' = '["'+$partitionKey+'"]'
}

Invoke-RestMethod -Method Delete -Uri $documentUri -Headers $headers -SkipHeaderValidation

$body = "Whish with Id " + $whish.id + " deleted successfully."

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
