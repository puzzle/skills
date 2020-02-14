import keycloakStub from "../helpers/keycloak-stub";
import { setupApplicationTest } from "ember-qunit";

export default function(hooks) {
  setupApplicationTest(hooks);

  hooks.beforeEach(function(assert) {
    this.owner.register("service:keycloak-session", keycloakStub);
  });
}
