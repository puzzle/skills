import { module, test } from "qunit";
import { helper } from "@ember/component/helper";
import { setupRenderingTest } from "ember-qunit";
import { click, render } from "@ember/test-helpers";
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

  test("Renders form with default values for name input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("input[id='name']")).hasText("");
  });

  test("Renders form with default values for email input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("input[id='email']")).hasText("");
  });

  test("Renders form with default values for degree input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("input[id='degree']")).hasText("");
  });

  test("Renders form with default value for person role, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    await click("[data-test-new-function]");

    assert.equal(
      this.element.querySelectorAll("#personRole-role > *").length,
      1
    );
    assert.equal(
      this.element.querySelectorAll("#personRole-level > *").length,
      1
    );
    assert.dom(this.element.querySelector(".percent-field input")).hasText("");
  });

  test("Renders form with default values for department, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(this.element.querySelectorAll("#department > *").length, 1);
  });

  test("Renders form with default values for company, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(this.element.querySelectorAll("#company > *").length, 1);
  });

  test("Renders form with default values for location input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("input[id='location']")).hasText("");
  });

  test("Renders form with default values for birthdate input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("#birth_date input")).hasText("");
  });

  test("Renders form with default values for dualNationality input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("#dualNational")).isNotChecked();
  });

  test("Renders form with default values for firstNationality input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert
      .dom(
        this.element.querySelector(
          "#nationality .ember-power-select-selected-item"
        )
      )
      .hasText("Schweiz");
  });
  test("Renders form with no secondNationality", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("#nationality2")).doesNotExist();
  });

  test("Renders form with secondNationality because dualNationality is checked, ", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    await click("#dualNational");
    assert.dom(this.element.querySelector("#nationality2")).hasText("");
  });

  test("Renders form with default values for maritalStatus input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );

    assert.dom(this.element.querySelector("#maritalStatus")).hasText("ledig");
  });

  test("Renders form with default values for shortname input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );

    assert.dom(this.element.querySelector("#shortname")).hasText("");
  });
});
