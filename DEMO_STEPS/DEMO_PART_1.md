# DEMO - Azure AD Protected API - Part 1

This first part is all about configuring the resources and local settings for the API, based on the cloned repository.

## Complete the AZ_SETUP steps

Complete all the required steps in the AZ_SETUP folder and the containing PowerShell / Az CLI commands. 

## Add local.settings.json to /api folder

The /api folder contains the Azure Functions local project, and needs a local.settings.json file. Add the file with the following settings, where the CosmosDB connectionstring is the connectionstring you got in AZ_SETUP.

```json
{
"IsEncrypted": false,
"Values": {
    "AzureWebJobsStorage": "",
    "FUNCTIONS_WORKER_RUNTIME_VERSION": "~7",
    "FUNCTIONS_WORKER_RUNTIME": "powershell",
    "Festive_CosmosDB": "AccountEndpoint=https://cosmos-elven-protected-api.documents.azure.com:443//;AccountKey=jnrSbHmSDDDVzo1St4mWSHn……;"
    },
"Host": {
    "CORS": "*"
    }
}
```

## Start the local Function App and make it RESTful

In the Terminal Window (launch a new shell if needed), start the local Function App runtime with *func start*.

Note that the Functions are not RESTful with different routes and as default methods all are using GET and POST.

Stop (CTRL+C) the Function runtime, and change each of the function to use the correct method only, eg. GET, POST (create), PUT (update/replace), DELETE, and as well add the route to be resource centric for *wish*, eg. for GetWhishes:

```json
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "HttpTrigger",
      "direction": "in",
      "name": "Request",
      "methods": [
        "get"
      ],
      "route": "whish/{id?}"      
    },
```

CreateWhish should be changed to:
```json
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "HttpTrigger",
      "direction": "in",
      "name": "Request",
      "methods": [
        "post"
      ],
      "route": "whish"      
    },
```

The DeleteWhish HttpTrigger in should be changed to:
```json
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "HttpTrigger",
      "direction": "in",
      "name": "Request",
      "methods": [
        "delete"
      ],
      "route": "whish/{id}"      
    },
```
And last the UpdateWhish HttpTrigger in to be changed to:
```json
{
  "bindings": [
    {
      "authLevel": "function",
      "type": "HttpTrigger",
      "direction": "in",
      "name": "Request",
      "methods": [
        "put"
      ],
      "route": "whish/{id}"
    },
```

Start the Function runtime locally again with *func start*. 

Now we can query the API locally, for example via Postman.

## Start the Node.js Web

Start the Web frontend in a new Terminal session in the frontend folder with *npm start*.

The web site can now be demoed via http://localhost:3000, and this will access the local API via Functions runtime.

