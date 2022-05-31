# Az PowerShell Commands for Creating Cosmos DB

# Connect to Azure and specified Tenant with Az PowerShell
Connect-AzAccount -Tenant '<your-tenant>.onmicrosoft.com'

# Connect to Azure and specified Tenant with Az Cli
az login --tenant '<tenant>'

# Set Subscription to use for Az PowerShell & Az Cli
Set-AzContext -SubscriptionName '<YOUR-SUBSCRIPTION-NAME>'
az account set --subscription '<YOUR-SUBSCRIPTION-NAME>'

# Environment specific variables to be used for global resource names
$yourOrg = "elven"

# Create a Resource Group
$rg = New-AzResourceGroup -Name "rg-demoazureadprotected-api" -Location "Norway East"

# Create a Cosmos DB Account
# Using Az Cli because of lack of support for Serverless capacity mode in current version of Az.CosmosDB 1.8
# $cosmosAccount = New-AzCosmosDBAccount -Name "cosmos-$yourOrg-protected-api" -Location "Norway East" -ResourceGroupName $rg.ResourceGroupName -ApiKind Sql
az cosmosdb create --name "cosmos-$yourOrg-protected-api" --resource-group $rg.ResourceGroupName --capabilities EnableServerless --locations regionName="Norway East"
# PS! you can use the switch EnableFreeTier for one Cosmos DB Account only in the subscription, so you can use that if available for your subscription
# --enable-free-tier true

# Create a Cosmos DB Sql Database and Container
$cosmosDB = New-AzCosmosDBSqlDatabase -ResourceGroupName $rg.ResourceGroupName -AccountName "cosmos-$yourOrg-protected-api" -Name "protectedapidb"
New-AzCosmosDBSqlContainer -AccountName "cosmos-$yourOrg-protected-api" -DatabaseName $cosmosDB.Name -ResourceGroupName $rg.ResourceGroupName -Name "whishes" -PartitionKeyPath /id -PartitionKeyKind Hash

# Get Connection Strings (for use in Functions API later)
$cosmosDBConnectionStrings = Get-AzCosmosDBAccountKey -ResourceGroupName $rg.ResourceGroupName -Name "cosmos-$yourOrg-protected-api" -Type "ConnectionStrings"
$cosmosDBConnectionStrings.'Primary SQL Connection String' | clip # to clipboard for pasting later

