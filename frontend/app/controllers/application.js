import { inject as service } from "@ember/service";
import Controller from "@ember/controller";
import ENV from "../config/environment";

export default Controller.extend({
  session: service("keycloak-session"),
  router: service(),
  helplink: ENV.helplink,

  init() {
    let sessionInfo = this.get("session.tokenParsed");
    this.username = sessionInfo.given_name + " " + sessionInfo.family_name;
  },

  actions: {
    transitionToProfile() {
      let people = this.get("store").findAll("person");
      people.then(() => {
        let person = people.filterBy("name", this.get("username"))[0];
        if (person == undefined) {
          this.get("router").transitionTo("people");
        } else {
          this.get("router").transitionTo("person", person.id);
        }
      });
    },

    logoutUser() {
      let session = this.get("session");
      session.logout();
    }
  }
});
