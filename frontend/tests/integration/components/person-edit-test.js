import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";
import { run } from "@ember/runloop";
import { settled } from "@ember/test-helpers";

module("Integration | Component | person-edit", function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function(assert) {
    this.owner.register("service:keycloak-session", keycloakStub);
  });

  test("it renders person-edit with validation error at name", async function(assert) {
    let person = run(() =>
      this.owner.lookup("service:store").createRecord("person")
    );
    person.email = "hansrudolf@gmail.com";
    person.title = "Construction Consultant";
    person.location = "Bern";
    person.birthdate = new Date(2019, 1, 19);
    person.shortname = "HR";
    this.set("person", person);

    await render(hbs`{{person-edit person=person}}`);
    this.$("button")[0].click();
    await settled();
    assert.ok(
      this.$("#validation-error")
        .text()
        .includes("Name can't be blank")
    );
  });

  test("it renders person-edit with validation error at title", async function(assert) {
    let person = run(() =>
      this.owner.lookup("service:store").createRecord("person")
    );
    person.name = "Hans Rudolf";
    person.email = "hansrudolf@gmail.com";
    person.location = "Bern";
    person.birthdate = new Date(2019, 1, 19);
    person.shortname = "HR";
    this.set("person", person);

    await render(hbs`{{person-edit person=person}}`);
    this.$("button")[0].click();
    await settled();
    assert.ok(
      this.$("#validation-error")
        .text()
        .includes("Title can't be blank")
    );
  });

  test("it renders person-edit with validation error at birthdate", async function(assert) {
    let person = run(() =>
      this.owner.lookup("service:store").createRecord("person")
    );
    person.name = "Hans Rudolf";
    person.email = "hansrudolf@gmail.com";
    person.title = "Construction Consultant";
    person.location = "Bern";
    person.shortname = "HR";
    this.set("person", person);

    await render(hbs`{{person-edit person=person}}`);
    this.$("button")[0].click();
    await settled();
    assert.ok(
      this.$("#validation-error")
        .text()
        .includes("Birthdate can't be blank")
    );
  });

  test("it renders person-edit with validation error at empty email", async function(assert) {
    let person = run(() =>
      this.owner.lookup("service:store").createRecord("person")
    );
    person.name = "Hans Rudolf";
    person.title = "Construction Consultant";
    person.location = "Bern";
    person.birthdate = new Date(2019, 1, 19);
    person.shortname = "HR";
    this.set("person", person);

    await render(hbs`{{person-edit person=person}}`);
    this.$("button")[0].click();
    await settled();
    assert.ok(
      this.$("#validation-error")
        .text()
        .includes("Email kann nicht leer sein")
    );
  });

  test("it renders person-edit with validation error at invalid email", async function(assert) {
    let person = run(() =>
      this.owner.lookup("service:store").createRecord("person")
    );
    person.name = "Hans Rudolf";
    person.email = "hans";
    person.title = "Construction Consultant";
    person.location = "Bern";
    person.birthdate = new Date(2019, 1, 19);
    person.shortname = "HR";
    this.set("person", person);

    await render(hbs`{{person-edit person=person}}`);
    this.$("button")[0].click();
    await settled();
    assert.ok(
      this.$("#validation-error")
        .text()
        .includes("Gib eine gültige Email Adresse ein")
    );
  });
});
