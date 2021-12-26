// OLD Msal v1 stuff: const myMSALObj = new Msal.UserAgentApplication(msalConfig);

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

