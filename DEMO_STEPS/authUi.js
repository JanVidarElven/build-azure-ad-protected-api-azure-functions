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
