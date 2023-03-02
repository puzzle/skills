import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | activity-form", function(hooks) {
  setupRenderingTest(hooks);

  test("should render edit form with all values", async function(assert) {
    assert.expect(2);

    this.set("mockActivity", {
      id: 1,
      role: "Designer who designs",
      description:
        "As a designer who designs I design designs for application to improve the UX design"
    });

    await render(hbs`<ActivityForm @activity={{mockActivity}} />`);

    assert.equal(
      this.element.querySelector("#role-input").value,
      "Designer who designs"
    );
    assert.equal(
      this.element.querySelector("#description-input").value,
      "As a designer who designs I design designs for application to improve the UX design"
    );
  });

  test("should render create form with empty fields", async function(assert) {
    assert.expect(2);

    await render(hbs`<ActivityForm @activity={{null}} />`);

    assert.equal(this.element.querySelector("#role-input").value, "");
    assert.equal(this.element.querySelector("#description-input").value, "");
  });

  test("should render all english translations correctly", async function(assert) {
    assert.expect(5);

    setLocale("en");

    await render(hbs`<ActivityForm @activity={{null}} />`);

    assert.equal(this.element.querySelector("#role-label").innerHTML, "Role");
    assert.equal(
      this.element.querySelector("#description-label").innerHTML,
      "Company details and description of activity"
    );
    assert.equal(
      this.element.querySelector("#submit-activity-button").innerHTML,
      "Save"
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

    setLocale("de");

    await render(hbs`<ActivityForm @activity={{null}} />`);

    assert.equal(this.element.querySelector("#role-label").innerHTML, "Rolle");
    assert.equal(
      this.element.querySelector("#description-label").innerHTML,
      "Firmenangaben und Beschreibung der Tätigkeit"
    );
    assert.equal(
      this.element.querySelector("#submit-activity-button").innerHTML,
      "Speichern"
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
