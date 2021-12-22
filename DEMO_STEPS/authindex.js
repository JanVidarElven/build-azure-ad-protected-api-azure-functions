
(async function () {
    const API = "http://127.0.0.1:7071/api";

    apiTokenResponse = await myMSALObj.acquireTokenSilent(tokenRequest).then(function (accessTokenResponse) {
        // Acquire token silent success
        accessToken = accessTokenResponse.accessToken;
        console.log ("Yaayh, got an access token!");
        axios.defaults.headers.common['Authorization'] = `Bearer ${accessToken}`;
        return accessToken;
    }).catch(function (error) {
        //Acquire token silent failure, and send an interactive request
        if (error.errorMessage.indexOf("interaction_required") !== -1) {
            console.log ("Need to sign in first...")
        }
        console.log(error);
    });
    
    new Vue({
      el: "#app",
      data: {
        showModal: false,
        whishes: [],
        pronouns: ["She/Her", "He/Him", "Ze/Zir"],
        newWhish: { name: "", whish: "", pronoun: {} },
        toast: {
          type: "danger",
          message: null,
          show: false
        }
      },
      mounted() {
        this.getWhishes();
      },
      methods: {
        getWhishes() {
          this.whishes = axios
            .get(`${API}/whish`)
            .then((response) => {
              this.whishes = response.data;
            })
            .catch((err) => {
              this.showError("Get", err.message);
            });
        },
        updateWhish(id, index, name, whish) {
          axios
            .put(`${API}/whish/${id}`, {"id": id, "index": index, "name": name, "whish": whish})
            .then(() => {
              this.showSuccess("Whish updated");
            })
            .catch((err) => {
              this.showError("Update", err.message);
            });
        },
        createWhish() {
          axios
            .post(`${API}/whish`, this.newWhish)
            .then((item) => {
              this.whishes.push(item.data);
              this.showSuccess("Whish created");
            })
            .catch((err) => {
              this.showError("Create", err.message);
            })
            .finally(() => {
              this.showModal = false;
            });
        },
        deleteWhish(id, index) {
          axios
            .delete(`${API}/whish/${id}`,
            {
              data: {
                index: index
              }
            })
            .then(() => {
              // use the index to remove from the whishes array
              this.whishes.splice(index, 1);
              this.showSuccess("Whish deleted");
            })
            .catch((err) => {
              this.showError("Delete", err.message);
            });
        },
        showError(action, message) {
          this.showToast(`${action} failed: ${message}`, "danger");
        },
        showSuccess(message) {
          this.showToast(message, "success");
        },
        showToast(message, type) {
          this.toast.message = message;
          this.toast.show = true;
          this.toast.type = type;
          setTimeout(() => {
            this.toast.show = false;
          }, 3000);
        }
      }
    });
  })();