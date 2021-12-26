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