import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";
import { getCookie } from "../helpers/get-cookie";

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

  cookieValue = null;

  beforeModel() {
    let cookieValue = getCookie();
    if (cookieValue !== undefined) {
      this.cookieValue = cookieValue;
    }
  }

  model({ q }) {
    if (q === undefined) {
      q = this.cookieValue;
    }
    if (q) {
      const url = "/api/people/search?q=" + q;
      return fetch(url, {
        method: "GET",
        headers: {
          Accept: "application/vnd.api+json,application/json",
          Authorization: `Bearer ${this.get("session.token")}`
        }
      }).then(res => res.json());
    }
    return q;
  }
}
