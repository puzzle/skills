import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | skillset-rated-filter", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders", async function(assert) {
    await render(hbs`{{skillset-rated-filter}}`);
    let text = this.element.textContent;

    assert.ok(text.includes("Alle"));
    assert.ok(text.includes("Bewertet"));
    assert.ok(text.includes("Unbewertet"));
  });
});
