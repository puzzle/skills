import { test, module } from "qunit";
import { helper } from "@ember/component/helper";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";

module("Integration | Component | person-form", function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function() {
    let router = this.owner.lookup("router:main");
    router.setupRouter();
    this.owner.register("service:keycloak-session", keycloakStub);
    this.owner.register(
      "helper:route-action",
      helper(arg => this.routeActions[arg])
    );
    this.routeActions = {
      submit(arg) {
        return Promise.resolve({ arg });
      },
      abort(arg) {
        return Promise.resolve({ arg });
      }
    };
  });

  test("Renders empty form if no person ", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    let nameInput = this.element.querySelector("input[id='name']");
    assert.dom(nameInput).hasText("", "Ueee");
  });
});
