import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { blur, fillIn, click, render, triggerEvent } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | project-form", function(hooks) {
  setupRenderingTest(hooks);

  test("should render edit form with all values", async function(assert) {
    assert.expect(4);

    this.set("mockProject", {
      title: "Designing designs",
      description:
        "In this project we Designers design designs to improve UX design",
      role: "Designer",
      technology: "Design Pro+ HD XD Premium Gold",
      monthFrom: 7,
      monthTo: 8,
      yearFrom: 1969,
      yearTo: 1970
    });

    await render(hbs`<ProjectForm @project={{mockProject}} />`);

    assert.equal(
      this.element.querySelector("#title-input").value,
      "Designing designs"
    );
    assert.equal(
      this.element.querySelector("#description-input").value,
      "In this project we Designers design designs to improve UX design"
    );
    assert.equal(this.element.querySelector("#role-input").value, "Designer");
    assert.equal(
      this.element.querySelector("#technology-input").value,
      "Design Pro+ HD XD Premium Gold"
    );
  });

  test("should render create form with empty fields", async function(assert) {
    assert.expect(4);

    await render(hbs`<ProjectForm @project={{null}} />`);

    assert.equal(this.element.querySelector("#title-input").value, "");
    assert.equal(this.element.querySelector("#description-input").value, "");
    assert.equal(this.element.querySelector("#role-input").value, "");
    assert.equal(this.element.querySelector("#technology-input").value, "");
  });

  test("should render all english translations in edit form correctly", async function(assert) {
    assert.expect(7);

    this.set("mockProject", {
      id: 1
    });

    setLocale("en");

    await render(hbs`<ProjectForm @project={{mockProject}} />`);

    assert.equal(
      this.element.querySelector("#title-label").innerHTML,
      "Project"
    );
    assert.equal(
      this.element.querySelector("#description-label").innerHTML,
      "Description"
    );
    assert.equal(
      this.element.querySelector("#role-label").innerHTML,
      "Role and Tasks"
    );
    assert.equal(
      this.element.querySelector("#technology-label").innerHTML,
      "Deployed technologies"
    );
    assert.equal(
      this.element.querySelector("#submit-project-button").innerHTML,
      "Save"
    );
    assert.equal(
      this.element.querySelector("#delete-with-confirmation").innerText,
      " Delete"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerHTML,
      "Cancel"
    );
  });

  test("should render all german translations in edit form correctly", async function(assert) {
    assert.expect(7);

    this.set("mockProject", {
      id: 1
    });

    setLocale("de");

    await render(hbs`<ProjectForm @project={{mockProject}} />`);

    assert.equal(
      this.element.querySelector("#title-label").innerHTML,
      "Projekt"
    );
    assert.equal(
      this.element.querySelector("#description-label").innerHTML,
      "Beschreibung"
    );
    assert.equal(
      this.element.querySelector("#role-label").innerHTML,
      "Rolle und Aufgaben"
    );
    assert.equal(
      this.element.querySelector("#technology-label").innerHTML,
      "Eingesetzte Technologien"
    );
    assert.equal(
      this.element.querySelector("#submit-project-button").innerHTML,
      "Speichern"
    );
    assert.equal(
      this.element.querySelector("#delete-with-confirmation").innerText,
      " Löschen"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerHTML,
      "Abbrechen"
    );
  });

  test("should render all english translations in create form correctly", async function(assert) {
    assert.expect(1);

    setLocale("en");

    await render(hbs`<ProjectForm @project={{null}} />`);

    //Only this translation check needed, all other translations are tested in the edit state translation test
    assert.equal(
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Save &amp; New"
    );
  });

  test("should render all german translations in create form correctly", async function(assert) {
    assert.expect(1);

    setLocale("de");

    await render(hbs`<ProjectForm @project={{null}} />`);

    //Only this translation check needed, all other translations are tested in the edit state translation test
    assert.equal(
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Speichern &amp; Neu"
    );
  });

  test("should turn on modal when cancel button is clicked", async function(assert) {
    assert.expect(2);

    await render(hbs`<ProjectForm @project={{null}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();

    await fillIn("#description-input", "New value");

    await click("#cancel-button");

    assert.dom(this.element.querySelector("#confirmation-modal")).exists();
  });

  test("should turn on modal when esc keyup event is triggered", async function(assert) {
    assert.expect(2);

    await render(hbs`<ProjectForm @project={{null}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();

    await fillIn("#description-input", "New value");

    await blur("#description-input");

    await triggerEvent(document, "keyup", { keyCode: 27 });

    assert.dom(this.element.querySelector("#confirmation-modal")).exists();
  });

  // eslint-disable-next-line max-len
  test("should select input and unfocus currently selected element on esc keyup event without opening modal", async function(assert) {
    assert.expect(3);

    await render(hbs`<ProjectForm @project={{null}} />`);

    await click("#title-input");

    assert.equal(document.activeElement.tagName, "INPUT");

    await triggerEvent(document, "keyup", { keyCode: 27 });

    assert.equal(document.activeElement.tagName, "BODY");

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();
  });
});
