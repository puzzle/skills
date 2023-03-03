import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
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

  test("should render all english translations correctly", async function(assert) {
    assert.expect(6);

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
    assert.expect(6);

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
      this.element.querySelector("#save-and-new-button").innerHTML,
      //HTML doesn't recognize '&' but it will recognize &amp; because it is equal to & in HTML
      "Speichern &amp; Neu"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerHTML,
      "Abbrechen"
    );
  });

  test("should render create form with empty fields", async function(assert) {
    assert.expect(2);

    await render(hbs`<EducationForm @education={{null}} />`);

    assert.equal(this.element.querySelector("#title-input").value, "");
    assert.equal(this.element.querySelector("#location-input").value, "");
  });
});
