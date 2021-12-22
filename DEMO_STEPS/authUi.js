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