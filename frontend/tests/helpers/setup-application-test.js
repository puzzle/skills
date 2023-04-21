import { setupApplicationTest } from "ember-qunit";
import keycloakStub from "../helpers/keycloak-stub";

export default function(hooks) {
  setupApplicationTest(hooks);

  hooks.beforeEach(function(assert) {
    deleteAllCookies();
    this.owner.register("service:keycloak-session", keycloakStub);
    fetch("/api/test_api", { method: "POST" });
  });

  function deleteAllCookies() {
    const cookies = document.cookie.split(";");
    for (let i = 0; i < cookies.length; i++) {
      const cookie = cookies[i];
      const eqPos = cookie.indexOf("=");
      const name = eqPos > -1 ? cookie.substring(0, eqPos) : cookie;
      document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
  }
}
