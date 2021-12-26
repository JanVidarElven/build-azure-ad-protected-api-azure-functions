# Demo Steps & Resources for Msal.js v2

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

  // Add here scopes for access token to be used at API endpoints.
  const tokenRequest = {
    scopes: ["api://festivetechcalendarapi/access_as_user", "api://festivetechcalendarapi/Whish.ReadWrite"]
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
const signOutButton = document.getElementById('signOut');

function showWelcomeMessage(account) {
  // Reconfiguring DOM elements
  welcomeDiv.innerHTML = `Welcome ${account.name}`;
  signInButton.classList.add('d-none');
  signOutButton.classList.remove('d-none');
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
const myMSALObj = new Msal.PublicClientApplication(msalConfig);

let username = "";

function signIn() {
  myMSALObj.loginPopup(loginRequest)
    .then(loginResponse => {
      console.log('id_token acquired at: ' + new Date().toString());
      console.log(loginResponse);

      if (myMSALObj.getAccount()) {
        showWelcomeMessage(myMSALObj.getAccount());
      }
    }).catch(error => {
      console.log(error);
    });
}

function signOut() {
  myMSALObj.logout();
}

function callWhishesAPI(theUrl, accessToken, callback) {
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.onreadystatechange = function () {
      if (this.readyState == 4 && this.status == 200) {
         callback(JSON.parse(this.responseText));
      }
  }
  xmlHttp.open("GET", theUrl, true); // true for asynchronous
  xmlHttp.setRequestHeader('Authorization', 'Bearer ' + accessToken);
  xmlHttp.send();
}

function getTokenPopup(request) {
  return myMSALObj.acquireTokenSilent(request)
    .catch(error => {
      console.log(error);
      console.log("silent token acquisition fails. acquiring token using popup");

      // fallback to interaction when silent call fails
        return myMSALObj.acquireTokenPopup(request)
          .then(tokenResponse => {
            return tokenResponse;
          }).catch(error => {
            console.log(error);
          });
    });
}

function seeWhishes() {
  if (myMSALObj.getAccount()) {
    getTokenPopup(tokenRequest)
      .then(response => {
        callWhishesAPI(apiConfig.whishesEndpoint, response.accessToken, updateUI);
        const token = response.accessToken;
        // profileButton.classList.add('d-none');
        // mailButton.classList.remove('d-none');
      }).catch(error => {
        console.log(error);
      });
  }
}


```