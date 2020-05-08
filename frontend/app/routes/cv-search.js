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
    if (q) {
      const url = "/api/people/search?q=" + q;
      return fetch(url).then(res => res.json());
    }
    return q;
  }
}
