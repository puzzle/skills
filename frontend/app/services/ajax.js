import classic from "ember-classic-decorator";
import { computed } from "@ember/object";
import { inject as service } from "@ember/service";
import AjaxService from "ember-ajax/services/ajax";

@classic
export default class _AjaxService extends AjaxService {
  @service("keycloak-session")
  session;

  namespace = "/api";

  @computed("session.token")
  get headers() {
    let headers = {
      Accept: "application/vnd.api+json,application/json"
    };
    let token = this.get("session.token");

    if (token) {
      headers["Authorization"] = `Bearer ${token}`;
    }
    return headers;
  }
}
