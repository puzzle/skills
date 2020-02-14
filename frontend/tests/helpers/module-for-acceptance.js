import { all, resolve } from "rsvp";
import { module } from "qunit";
import startApp from "../helpers/start-app";
import destroyApp from "../helpers/destroy-app";
import keycloakStub from "../helpers/keycloak-stub";
import { setupApplicationTest } from "ember-qunit";

export default function(name, options = {}) {
  module(name, function(hooks) {
    setupApplicationTest(hooks);

    hooks.beforeEach(function(assert) {
      this.owner.register("service:keycloak-session", keycloakStub);
    });
  });
}
