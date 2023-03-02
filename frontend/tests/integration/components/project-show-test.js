import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | project-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with correct values", async function(assert) {
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

    await render(hbs`<ProjectShow @project={{mockProject}} />`);
    assert.equal(
      this.element.querySelector("#date-title").innerText,
      "07.1969 - 08.1970 | Designing designs"
    );
    assert.equal(
      this.element.querySelector("#description").innerHTML,
      "In this project we Designers design designs to improve UX design"
    );
    assert.equal(this.element.querySelector("#role").innerHTML, "Designer");
    assert.equal(
      this.element.querySelector("#technology").innerHTML,
      "Design Pro+ HD XD Premium Gold"
    );
  });

  test("should render all german translations correctly", async function(assert) {
    assert.expect(1);

    setLocale("de");

    await render(hbs`<ProjectShow @project={{null}} />`);

    assert.equal(
      this.element.querySelector("#project-edit-button").innerText,
      "Bearbeiten"
    );
  });

  test("should render all english translations correctly", async function(assert) {
    assert.expect(1);

    setLocale("en");

    await render(hbs`<ProjectShow @project={{null}} />`);

    assert.equal(
      this.element.querySelector("#project-edit-button").innerText,
      "Edit"
    );
  });
});
