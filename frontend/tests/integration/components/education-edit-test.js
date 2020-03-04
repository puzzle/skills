import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";

module("Integration | Component | education-edit", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders", async function(assert) {
    this.education = {
      yearFrom: 1990,
      monthFrom: 2,
      yearTo: 2000,
      monthTo: 5
    };

    await render(hbs`<EducationEdit @education={{education}}/>`);

    let text = this.$().text();

    assert.ok(text.includes("Monat"));
    assert.ok(text.includes("Jahr"));
  });
});
