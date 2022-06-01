# DEMO - Azure AD Protected API - Part 4

Part 4 will show demo steps & resources for Msal.js v2 in the Web Frontend.
## Add authConfig.js

Add a file authConfig.js to the frontend folder with the following code:

```javascript
const msalConfig = {
    auth: {
      clientId: "<your-app-id>",
      authority: "https://login.microsoftonline.com/common",
      redirectUri: "http://localhost:3000",
    },
    cache: {
      cacheLocation: "sessionStorage", // This configures where your cache will be stored
      storeAuthStateInCookie: false, // Set this to "true" if you are having issues on IE11 or Edge
    }
  };

  // Add here scopes for id token to be used at MS Identity Platform endpoints.
  const loginRequest = {
    scopes: ["openid", "profile"]
  };

```

Change the above code to your app id from the frontend app registration, and if you have other names for the api scopes change that as well for the tokenRequest constant.

## Add apiConfig.js

Add a file apiConfig.js to the frontend folder with the following code:

```javascript
const apiConfig = {
    whishesEndpoint: "https://<yourfunctionapp>.azurewebsites.net/api/whish/"
  };
```

Change the above endpoint to your function app name.

## Add authUI.js

Add a file authUI.js to the frontend folder with the following code:

```javascript
// Select DOM elements to work with
const welcomeDiv = document.getElementById("welcomeMessage");
const signInButton = document.getElementById("signIn");

function showWelcomeMessage(account) {
  // Reconfiguring DOM elements
  welcomeDiv.innerHTML = `Welcome ${account.username}`;
  signInButton.setAttribute("onclick", "signOut();");
  signInButton.setAttribute('class', "btn btn-success")
  signInButton.innerHTML = "Sign Out";
  console.log (account.username);  
}

function updateUI(data, endpoint) {
  console.log('Whishes API responded at: ' + new Date().toString());

}
```

The above code is used for hiding/showing document elements based on if the user is signed in or not.

## Add authPopup.js

Add a new file to the frontend folder with the name authPopup.js, and add the following Javascript code:

```javascript

// Create the main myMSALObj instance
// configuration parameters are located at authConfig.js
const myMSALObj = new msal.PublicClientApplication(msalConfig);

let username = "";

function loadPage() {
    /**
     * See here for more info on account retrieval:
     * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-common/docs/Accounts.md
     */
    const currentAccounts = myMSALObj.getAllAccounts();
    if (currentAccounts === null) {
        return;
    } else if (currentAccounts.length > 1) {
        // Add choose account code here
        console.warn("Multiple accounts detected.");
    } else if (currentAccounts.length === 1) {
        username = currentAccounts[0].username;
        showWelcomeMessage(currentAccounts[0]);
    }
}

function handleResponse(resp) {
    if (resp !== null) {
        username = resp.account.username;
        console.log('id_token acquired at: ' + new Date().toString());        
        showWelcomeMessage(resp.account);
    } else {
        loadPage();
    }
}

function signIn() {
    myMSALObj.loginPopup(loginRequest).then(handleResponse).catch(error => {
        console.error(error);
    });
}

function signOut() {
    const logoutRequest = {
        account: myMSALObj.getAccountByUsername(username)
    };

    myMSALObj.logout(logoutRequest);
}

loadPage();

```

## Replace index.js

Next, rename the existing index.js, for example to noauth_index.js, and copy the contents of the authindex.js in this repo to a new index.js file.

This will implement support for MSAL authentication, and securely authenticating to the API.

## Replace index.html

Rename the existing index.html, for example to noauth_index.html, and copy the contents of the authindex.html in this repo to a new index.html file.

This will implement sign in and authorization support in the web front end.

## Test localhost

Run *npm start* and now test the sign in and authentication to the API.