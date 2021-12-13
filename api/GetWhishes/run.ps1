using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $CosmosInput )

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Host "Total number of wishes: $($CosmosInput.count)"

# Check if a specific id should be returned or all whishes
If ($Request.Params.id) {
    # Get Whish by Id
    [array]$Whishes = $CosmosInput | Where-Object { $_.id -eq $Request.Params.id}
}
else {
    # Get All Whishes
    [array]$Whishes = $CosmosInput
}

# Change the output (if needed) if there are not entries in the CosmosDB
if ($Whishes.Count -eq 0) {
    $response = $Whishes | Select-Object Id, Name, Whish, Pronoun, Created
}
else {
    $response = $Whishes | Select-Object Id, Name, Whish, Pronoun, Created
}

$jsonResponse = ConvertTo-Json @($response)

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $jsonResponse
})
