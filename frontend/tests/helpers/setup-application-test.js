import { setupApplicationTest } from "ember-qunit";
import keycloakStub from "../helpers/keycloak-stub";

export default function(hooks) {
  setupApplicationTest(hooks);

  hooks.beforeEach(function(assert) {
    this.owner.register("service:keycloak-session", keycloakStub);
    fetch("/api/test_api", { method: "POST" });
  });
}
