import { inject as service } from "@ember/service";
import Controller from "@ember/controller";
import ENV from "../config/environment";

export default Controller.extend({
  session: service("keycloak-session"),
  router: service(),
  helplink: ENV.helplink,

  init() {
    this._super(...arguments);
    let session = this.get("session");
    let sessionInfo = session.get("tokenParsed");
    this.set(
      "username",
      sessionInfo.given_name + " " + sessionInfo.family_name
    );
    this.set("isAdmin", session.hasResourceRole("ADMIN"));
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
