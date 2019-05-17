import Service from "@ember/service";
import { inject as service } from "@ember/service";
import Ember from "ember";

export default Service.extend({
  airbrake: service(),
  session: service("keycloak-session"),

  init() {
    this._super(...arguments);

    Ember.onerror = error => {
      const sessionInfo = this.get("session.tokenParsed");
      const username = sessionInfo.given_name + " " + sessionInfo.family_name;
      const session = {
        username,
        name: error.toLocaleString(),
        url: window.location.href,
        filename: error.fileName,
        linenumber: error.lineNumber,
        stack: error.stack
      };

      let airbrake = this.get("airbrake");
      airbrake.setSession(session);

      throw error;
    };
  }
});
