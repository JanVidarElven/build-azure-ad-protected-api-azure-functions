using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request to create a new whish."

# Generate new guid for id and current date time
$guid = New-Guid
$datetime = Get-Date

# Create a object to write the new whish to the database
$whish = [PSCustomObject]@{
    id = $guid.Guid
    name = $Request.Body.name
    whish = $Request.Body.whish
    pronoun = [PSCustomObject]@{ 
        name = $Request.Body.pronoun.name 
    }
    created = $datetime.ToString()
    uid = ""
    upn = ""
}

# Push new whish to Cosmos DB
Push-OutputBinding -Name CosmosOutput -Value $whish

Write-Host ("Whish with Id " + $whish.id + " created successfully.")

$jsonResponse = $whish | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $jsonResponse
})
