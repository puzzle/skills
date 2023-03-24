import hbs from "htmlbars-inline-precompile";
import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";

module("or", "Integration | Helper | or", function(hooks) {
  setupRenderingTest(hooks);

  test("it works", async function(assert) {
    await render(hbs`{{or 0 1}}`);
    assert.dom("body", document).includesText("1");

    await render(hbs`{{or 1 0}}`);
    assert.dom("body", document).includesText("1");

    await render(hbs`{{or 0 false 'hallo'}}`);
    assert.dom("body", document).includesText("hallo");
  });
});
