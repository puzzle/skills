import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { blur, click, fillIn, render, triggerEvent } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | education-form", function(hooks) {
  setupRenderingTest(hooks);

  test("should render edit form with all values", async function(assert) {
    assert.expect(2);

    this.set("mockEducation", {
      id: 1,
      title: "Master of Design",
      location: "Gibb"
    });

    await render(hbs`<EducationForm @education={{mockEducation}} />`);

    assert.equal(
      this.element.querySelector("#title-input").value,
      "Master of Design"
    );
    assert.equal(this.element.querySelector("#location-input").value, "Gibb");
  });

  test("should render all english translations in edit form correctly", async function(assert) {
    assert.expect(5);

    this.set("mockEducation", {
      id: 1
    });

    setLocale("en");

    await render(hbs`<EducationForm @education={{mockEducation}} />`);

    assert.equal(
      this.element.querySelector("#title-label").innerHTML,
      "Education"
    );
    assert.equal(
      this.element.querySelector("#location-label").innerHTML,
      "Location"
    );
    assert.equal(
      this.element.querySelector("#submit-education-button").innerHTML,
      "Save"
    );
    assert.equal(
      this.element.querySelector("#delete-with-confirmation").innerText,
      " Delete"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerText,
      "Cancel"
    );
  });

  test("should render all german translations in edit form correctly", async function(assert) {
    assert.expect(5);

    this.set("mockEducation", {
      id: 1
    });

    setLocale("de");

    await render(hbs`<EducationForm @education={{mockEducation}} />`);

    assert.equal(
      this.element.querySelector("#title-label").innerHTML,
      "Ausbildung"
    );
    assert.equal(
      this.element.querySelector("#location-label").innerHTML,
      "Ausbildungsort"
    );
    assert.equal(
      this.element.querySelector("#submit-education-button").innerHTML,
      "Speichern"
    );
    assert.equal(
      this.element.querySelector("#delete-with-confirmation").innerText,
      " Löschen"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerText,
      "Abbrechen"
    );
  });

  test("should render create form with empty fields", async function(assert) {
    assert.expect(2);

    await render(hbs`<EducationForm @education={{null}} />`);

    assert.equal(this.element.querySelector("#title-input").value, "");
    assert.equal(this.element.querySelector("#location-input").value, "");
  });

  test("should render all english translations in create form correctly", async function(assert) {
    assert.expect(1);

    setLocale("en");

    await render(hbs`<EducationForm @education={{null}} />`);

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

    await render(hbs`<EducationForm @education={{null}} />`);

    //Only this translation check needed, all other translations are tested in the edit state translation test
    assert.equal(
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Speichern &amp; Neu"
    );
  });

  test("should turn on modal when cancel button is clicked", async function(assert) {
    assert.expect(2);

    await render(hbs`<EducationForm @education={{null}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();

    await fillIn("#title-input", "New value");

    await click("#cancel-button");

    assert.dom(this.element.querySelector("#confirmation-modal")).exists();
  });

  test("should turn on modal when esc keyup event is triggered", async function(assert) {
    assert.expect(2);

    await render(hbs`<EducationForm @education={{null}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();

    await fillIn("#title-input", "New value");

    await blur("#title-input");

    await triggerEvent(document, "keyup", { keyCode: 27 });

    assert.dom(this.element.querySelector("#confirmation-modal")).exists();
  });

  // eslint-disable-next-line max-len
  test("should select input and unfocus currently selected element on esc keyup event without opening modal", async function(assert) {
    assert.expect(3);

    await render(hbs`<EducationForm @education={{null}} />`);

    await click("#title-input");

    assert.equal(document.activeElement.tagName, "INPUT");

    await triggerEvent(document, "keyup", { keyCode: 27 });

    assert.equal(document.activeElement.tagName, "BODY");

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();
  });
});
