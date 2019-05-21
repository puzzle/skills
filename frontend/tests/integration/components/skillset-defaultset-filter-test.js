import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | skillset-defaultset-filter", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders", async function(assert) {
    await render(hbs`{{skillset-defaultset-filter}}`);
    let text = this.$().text();

    assert.ok(text.includes("Alle"));
    assert.ok(text.includes("Neue"));
    assert.ok(text.includes("Default"));
  });
});
