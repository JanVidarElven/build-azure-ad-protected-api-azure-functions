using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $CosmosInput)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request to update a whish."

# Check id and get item to update
If ($Request.Params.id) {
    $whish = $CosmosInput | Where-Object { $_.id -eq $Request.Params.id}

    # Updating item values
    If ($Request.Body.name) {
        $whish.name = $Request.Body.name
    }
    If ($Request.Body.whish) {
        $whish.whish = $Request.Body.whish
    }
}
else {
    
}

Push-OutputBinding -Name CosmosOutput -Value $whish

$body = "Whish with Id " + $whish.id + " updated successfully."

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
