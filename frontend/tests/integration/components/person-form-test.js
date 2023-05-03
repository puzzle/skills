import { module, test } from "qunit";
import { helper } from "@ember/component/helper";
import { setupRenderingTest } from "ember-qunit";
import { click, render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";
import { setLocale } from "ember-intl/test-support";
import EmberObject from "@ember/object";
import Service from "@ember/service";

const storeStub = Service.extend({
  findAll(type) {
    if (type === "role") {
      return [{ id: 1, name: "New Role" }];
    } else if (type === "language") {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          resolve([
            EmberObject.create({ id: 1, name: "Afrikaans", iso1: "AF" })
          ]);
        }, 300000);
      });
    } else if (type === "personRoleLevel") {
      return [EmberObject.create({ id: 1, level: "S1" })];
    } else if (type === "department") {
      return [EmberObject.create({ id: 1, name: "/bbt" })];
    } else if (type === "company") {
      return [EmberObject.create({ id: 1, name: "Bewerber" })];
    }
  }
});

module("Integration | Component | person-form-new", function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function() {
    setLocale("en");
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
    assert.dom(this.element.querySelector("#nationality2")).hasText("Schweiz");
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

module("Integration | Component | person-form-edit", function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function() {
    setLocale("en");
    this.owner.unregister("service:store");
    this.owner.register("service:store", storeStub);
    this.owner.register("service:keycloak-session", keycloakStub);
    this.owner.register(
      "helper:route-action",
      helper(arg => this.routeActions[arg])
    );
    let router = this.owner.lookup("router:main");
    router.setupRouter();
    this.routeActions = {
      submit(arg) {
        return Promise.resolve({ arg });
      },
      abort(arg) {
        return Promise.resolve({ arg });
      }
    };

    this.set("mockPerson", {
      name: "Max Mustermann",
      email: "max.mustermann@gmail.com",
      title: "title",
      department: { id: 1, name: "/bbt" },
      company: { id: 1, name: "Bewerber" },
      location: "Some city",
      birthdate: Date.parse("04 Dec 1995 00:00:00 GMT"),
      nationality: "CH",
      maritalStatusView: "Verheiratet",
      shortname: "shorty",
      personRoles: [
        {
          role: { id: 1, name: "Captain" },
          level: "S1",
          percent: 20
        }
      ],
      languageSkills: [
        EmberObject.create({ language: "AF", level: "Keine", certificate: "" })
      ]
    });
  });

  test("Renders form with correct values for name input field", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector("input[id='name']").value,
      "Max Mustermann"
    );
  });

  test("Renders form with correct values for email input field", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector("input[id='email']").value,
      "max.mustermann@gmail.com"
    );
  });

  test("Renders form with correct values for degree input field", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector("input[id='degree']").value,
      "title"
    );
  });

  test("Renders form with default value for person role, if no person", async function(assert) {
    await render(
      // eslint-disable-next-line max-len
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector(
        "#personRole-role .ember-power-select-selected-item"
      ).innerText,
      "Captain"
    );

    assert.equal(
      this.element.querySelector(
        "#personRole-level .ember-power-select-selected-item"
      ).innerText,
      "S1"
    );
    assert.equal(
      this.element.querySelector(".percent-field input").value,
      "20"
    );
  });

  test("Renders form with correct values for department", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector(
        "#department .ember-power-select-selected-item"
      ).innerText,
      "/bbt"
    );
  });

  test("Renders form with correct values for company", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector("#company .ember-power-select-selected-item")
        .innerText,
      "Bewerber"
    );
  });

  test("Renders form with correct values for location input field", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector("input[id='location']").value,
      "Some city"
    );
  });

  test("Renders form with correct value for birthdate input field", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(
      this.element.querySelector("#birth_date input").value,
      "04.12.1995"
    );
  });

  test("Renders form with correct value for nationality", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("#dualNational")).isNotChecked();
    assert.equal(
      this.element.querySelector(
        "#nationality .ember-power-select-selected-item"
      ).innerText,
      "Schweiz"
    );
  });

  test("Renders form with correct values in both nationality dropdowns", async function(assert) {
    this.mockPerson.nationality2 = "DE";
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.dom(this.element.querySelector("#dualNational")).isChecked();
    assert.equal(
      this.element.querySelector(
        "#nationality .ember-power-select-selected-item"
      ).innerText,
      "Schweiz"
    );
    assert.equal(
      this.element.querySelector(
        "#nationality2 .ember-power-select-selected-item"
      ).innerText,
      "Deutschland"
    );
  });

  test("Renders form with default values for maritalStatus input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert
      .dom(this.element.querySelector("#maritalStatus"))
      .hasText("Verheiratet");
  });

  test("Renders form with default values for shortname input field, if no person", async function(assert) {
    await render(
      hbs`<PersonForm @person={{mockPerson}} @submit={{route-action "submit"}} @abort={{route-action "abort"}} />`
    );
    assert.equal(this.element.querySelector("#shortname").value, "shorty");
  });
});
