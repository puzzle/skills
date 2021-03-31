import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import DS from "ember-data";
import { UnauthorizedError, ForbiddenError } from "ember-ajax/errors";
import config from "../config/environment";

@classic
export default class ApplicationRoute extends Route {
  @service("keycloak-session")
  session;

  @service
  envSettings;

  @service
  moment;

  @service
  intl;

  config = config;

  async beforeModel() {
    this.get("moment").setLocale("de");
    this.get("intl").setLocale(["de"]);
    super.beforeModel(...arguments);

    let session = this.get("session");

    // Keycloak constructor arguments as described in the keycloak documentation.

    await this.envSettings.fetchEnv();

    let options = {
      url: this.config.keycloak.url, //add your url here
      realm: this.config.keycloak.realm, // add your realm here
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
  }

  isAuthError(error) {
    return (
      error instanceof UnauthorizedError ||
      error instanceof ForbiddenError ||
      error instanceof DS.UnauthorizedError ||
      error instanceof DS.ForbiddenError
    );
  }

  @action
  error(error, transition) {
    if (this.isAuthError(error)) {
      this.get("session").invalidate();
    }
  }

  @action
  invalidateSession() {
    this.get("session").invalidate();
  }
}
