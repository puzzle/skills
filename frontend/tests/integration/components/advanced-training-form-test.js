import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
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

  test("should render all english translations correctly", async function(assert) {
    assert.expect(5);

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
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Save &amp; New"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerHTML,
      "Cancel"
    );
  });

  test("should render all german translations correctly", async function(assert) {
    assert.expect(5);

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
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Speichern &amp; Neu"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerHTML,
      "Abbrechen"
    );
  });
});
