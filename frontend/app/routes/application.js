import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import DS from "ember-data";
import { UnauthorizedError, ForbiddenError } from "ember-ajax/errors";
import config from "../config/environment";

export default Route.extend({
  session: service("keycloak-session"),
  moment: service(),
  config,

  beforeModel() {
    this.get("moment").setLocale("de");
    this._super(...arguments);

    let session = this.get("session");

    // Keycloak constructor arguments as described in the keycloak documentation.
    let options = {
      url: "server_url", //add your url here
      realm: "realm_name", // add your realm here
      clientId: this.config.keycloak.clientId, // add your clientId here
      credentials: {
        secret: this.config.keycloak.secret // add your secret here
      }
    };

    // this will result in a newly constructed keycloak object
    session.installKeycloak(options);

    // set any keycloak init parameters where defaults need to be overidden
    session.set("responseMode", "fragment");
    // finally init the service and return promise to pause router.
    return session.initKeycloak();
  },

  isAuthError(error) {
    return (
      error instanceof UnauthorizedError ||
      error instanceof ForbiddenError ||
      error instanceof DS.UnauthorizedError ||
      error instanceof DS.ForbiddenError
    );
  },

  actions: {
    error(error, transition) {
      if (this.isAuthError(error)) {
        this.get("session").invalidate();
      }
    },
    invalidateSession() {
      this.get("session").invalidate();
    }
  }
});
