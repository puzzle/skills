import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";

@classic
export default class CvSearchRoute extends Route.extend(
  KeycloakAuthenticatedRouteMixin
) {
  queryParams = {
    q: {
      refreshModel: true,
      replace: true
    }
  };

  model({ q }) {
    return q ? this.store.query("person", { q }) : q;
  }
}
