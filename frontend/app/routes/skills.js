import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";
import Route from "@ember/routing/route";
import { inject as service } from "@ember/service";

export default Route.extend(KeycloakAuthenticatedRouteMixin, {
  session: service("keycloak-session"),
  router: service(),

  beforeModel() {
    if (!this.get("session").hasResourceRole("ADMIN"))
      this.get("router").transitionTo("people");
  }
});
