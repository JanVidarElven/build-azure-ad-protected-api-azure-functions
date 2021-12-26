# Demo Steps & Resources for Azure Functions

## Add Module for Extracting JWT Token and Claims

```powershell
@{
    # For latest supported version, go to 'https://www.powershellgallery.com/packages/Az'.
    # To use the Az module in your function app, please uncomment the line below.
    'Az' = '7.*'
    'JWTDetails' = '1.*'
}
```

## Add Authorization Logic to Functions

Add after Trigger:

```powershell
# BEGIN: TO-BE-ADDED-IN-DEMO
# Check if Authorization Header and get Access Token
$AuthHeader = $Request.Headers.'Authorization'
If ($AuthHeader) {
    $AuthHeader
    $parts = $AuthHeader.Split(" ")
    $accessToken = $parts[1]
    $jwt = $accessToken | Get-JWTDetails

    Write-Host "This is an authorized request by $($jwt.name) [$($jwt.preferred_username)]"

    # Check Tenant Id to be another Azure AD Organization or Personal Microsoft
    If ($jwt.tid -eq "9188040d-6c67-4c5b-b112-36a304b66dad") {
        Write-Host "This is a Personal Microsoft Account"
    } else {
        Write-Host "This is a Work or School Account from Tenant ID : $($jwt.tid)"
    } 
}
# END: TO-BE-ADDED-IN-DEMO

```

For Get Whishes, add after getting Cosmos DB Items:

```powershell
# BEGIN: TO-BE-ADDED-IN-SECOND-DEMO
If ($AuthHeader) {
    Write-Host "The Requesting User has the Scopes: $($jwt.scp)"
    # Check for Scopes and Authorize
    If ($jwt.scp -notcontains "Whish.ReadWrite.All") {
        Write-Host "User is only authorized to see own whishes!"
        # $Whishes = $Whishes | Where-Object {$_.uid -eq $jwt.oid}
        # $Whishes = $Whishes | Where-Object {$_.upn -eq $jwt.preferred_username }
        $Whishes = $Whishes | Where-Object {$_.name -eq $jwt.name}
    }
} else {
    Write-Host "No Auth, return nothing!"
    $Whishes = $Whishes | Where-Object {$_.id -eq $null}
}
# END: TO-BE-ADDED-IN-SECOND-DEMO
```

For Create Whish, add so that the Claims User Id and Upn are added to the document item:

```powershell
# Create a object to write the new whish to the database
$whish = [PSCustomObject]@{
    id = $guid.Guid
    name = $Request.Body.name
    whish = $Request.Body.whish
    pronoun = [PSCustomObject]@{ 
        name = $Request.Body.pronoun.name 
    }
    created = $datetime.ToString()
    uid = $jwt.oid
    upn = $jwt.preferred_username
}

```