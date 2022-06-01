# DEMO - Azure AD Protected API - Part 3

## Require Authentication for Azure Function App

In the Azure Portal and for the Function App, go to Authentication, and add a Microsoft Identity Provider. Follow these steps:

1. Select existing App Registration, and find the Whishes Client App Registration
1. Select to Require Authentication, and provide a 401 Unauthorized (recommended for API) response for unauthenticated requests.
1. Finish adding the Identity Provider.

Save the Function App settings.

## Configure Audience for Authorization

Go into the Authentication setup again, and edit the Identity Provider. This time add allowed audiences which is the App ID for the Whishes API App Registration. 

This represent the resource that the Access Token will be for.

## Monitor Function App & Test in Postman

Send both unauthenticated and authenticated requests in Postman and check response. When authenticated check monitor in Function for running requests.


