import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { blur, click, fillIn, render, triggerEvent } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | advanced-training-form", function(hooks) {
  setupRenderingTest(hooks);

  test("should render edit form with all values", async function(assert) {
    assert.expect(1);

    this.set("mockAdvancedTraining", {
      id: 1,
      description:
        "I learned to design to be a designer who designs a lot of nice designs"
    });

    await render(
      hbs`<AdvancedTrainingForm @advancedTraining={{mockAdvancedTraining}} />`
    );

    assert.equal(
      this.element.querySelector("#description-input").value,
      "I learned to design to be a designer who designs a lot of nice designs"
    );
  });

  test("should render create form with empty fields", async function(assert) {
    assert.expect(1);

    await render(hbs`<AdvancedTrainingForm @advancedTraining={{null}} />`);

    assert.equal(this.element.querySelector("#description-input").value, "");
  });

  test("should render all english translations in edit form correctly", async function(assert) {
    assert.expect(4);

    this.set("mockAdvancedTraining", {
      id: 1
    });

    setLocale("en");

    await render(
      hbs`<AdvancedTrainingForm @advancedTraining={{mockAdvancedTraining}} />`
    );

    assert.equal(
      this.element.querySelector("#description-label").innerHTML,
      "Description"
    );
    assert.equal(
      this.element.querySelector("#submit-advanced-training-button").innerHTML,
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
    assert.expect(4);

    this.set("mockAdvancedTraining", {
      id: 1
    });

    setLocale("de");

    await render(
      hbs`<AdvancedTrainingForm @advancedTraining={{mockAdvancedTraining}} />`
    );

    assert.equal(
      this.element.querySelector("#description-label").innerHTML,
      "Beschreibung"
    );
    assert.equal(
      this.element.querySelector("#submit-advanced-training-button").innerHTML,
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

    await render(hbs`<AdvancedTrainingForm @advancedTraining={{null}} />`);

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

    await render(hbs`<AdvancedTrainingForm @advancedTraining={{null}} />`);

    //Only this translation check needed, all other translations are tested in the edit state translation test
    assert.equal(
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Speichern &amp; Neu"
    );
  });

  test("should turn on modal when cancel button is clicked", async function(assert) {
    assert.expect(2);

    await render(hbs`<AdvancedTrainingForm @advancedTraining={{null}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();

    await fillIn("#description-input", "New value");

    await click("#cancel-button");

    assert.dom(this.element.querySelector("#confirmation-modal")).exists();
  });

  test("should turn on modal when esc keyup event is triggered", async function(assert) {
    assert.expect(2);

    await render(hbs`<AdvancedTrainingForm @advancedTraining={{null}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();

    await fillIn("#description-input", "New value");

    await blur("#description-input");

    await triggerEvent(document, "keyup", { keyCode: 27 });

    assert.dom(this.element.querySelector("#confirmation-modal")).exists();
  });

  // eslint-disable-next-line max-len
  test("should select textarea and unfocus currently selected element on esc keyup event without opening modal", async function(assert) {
    assert.expect(3);

    await render(hbs`<AdvancedTrainingForm @advancedTraining={{null}} />`);

    await click("#description-input");

    assert.equal(document.activeElement.tagName, "TEXTAREA");

    await triggerEvent(document, "keyup", { keyCode: 27 });

    assert.equal(document.activeElement.tagName, "BODY");

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();
  });
});
