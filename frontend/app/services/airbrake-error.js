import Service from "@ember/service";
import { inject as service } from "@ember/service";
import Ember from "ember";

export default Service.extend({
  airbrake: service(),
  session: service(),

  init() {
    this._super(...arguments);

    Ember.onerror = error => {
      const ldap_uid = this.get("session.session.authenticated.ldap_uid");
      const session = {
        ldap_uid,
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
