import { inject as service } from "@ember/service";
import { computed } from "@ember/object";
import AjaxService from "ember-ajax/services/ajax";

export default AjaxService.extend({
  session: service("keycloak-session"),
  namespace: "/api",

  headers: computed("session.token", {
    get() {
      let headers = {
        Accept: "application/vnd.api+json,application/json"
      };
      let token = this.get("session.token");

      if (token) {
        headers["Authorization"] = `Bearer ${token}`;
      }
      return headers;
    }
  })
});
