<# 
https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac

00000000-0000-0000-0000-000000000001	
Cosmos DB Built-in Data Reader	
Microsoft.DocumentDB/databaseAccounts/readMetadata
Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read
Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery
Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed

00000000-0000-0000-0000-000000000002	
Cosmos DB Built-in Data Contributor	
Microsoft.DocumentDB/databaseAccounts/readMetadata
Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*
Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/* 

Azure PowerShell: Az.CosmosDB version 1.2.0 or higher
Azure CLI: version 2.24.0 or higher
#>

$resourceGroupName = "<myResourceGroup>"
$accountName = "<myCosmosAccount>"
$readOnlyRoleDefinitionId = "<roleDefinitionId>" # as fetched above
$principalId = "<aadPrincipalId>"
New-AzCosmosDBSqlRoleAssignment -AccountName $accountName `
    -ResourceGroupName $resourceGroupName `
    -RoleDefinitionId $readOnlyRoleDefinitionId `
    -Scope "/" `
    -PrincipalId $principalId

$subscriptionId = "<subscriptionId_for_Azure_subscription_for_resources>"
Set-AzContext -Subscription $subscriptionId
$principalUpn = "<user_upn_for_member_or_guest_to_assign_access>"
$managedIdentityName = "<name_of_managed_identity_connected_to_function_app>"

$resourceGroupName = "rg-festivetechcalendar"
$accountName = "festivetechcalendar-christmaswhishes"
$readOnlyRoleDefinitionId = "00000000-0000-0000-0000-000000000001" # as fetched above
$contributorRoleDefinitionId = "00000000-0000-0000-0000-000000000002" # as fetched above

$principalId = (Get-AzADUser -UserPrincipalName $principalUpn).Id
New-AzCosmosDBSqlRoleAssignment -AccountName $accountName `
    -ResourceGroupName $resourceGroupName `
    -RoleDefinitionId $contributorRoleDefinitionId `
    -Scope "/" `
    -PrincipalId $principalId

$servicePrincipalId = (Get-AzADServicePrincipal -DisplayName $managedIdentityName).Id
New-AzCosmosDBSqlRoleAssignment -AccountName $accountName `
    -ResourceGroupName $resourceGroupName `
    -RoleDefinitionId $contributorRoleDefinitionId `
    -Scope "/" `
    -PrincipalId $servicePrincipalId

