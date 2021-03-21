import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("helper:or", function(hooks) {
  setupRenderingTest(hooks);

  test("it works", async function(assert) {
    await render(hbs`{{or 0 1}}`);

    assert.dom(this.element).hasText("1");

    await render(hbs`{{or 1 0}}`);

    assert.dom(this.element).hasText("1");

    await render(hbs`{{or 0 false 'hallo'}}`);

    assert.dom(this.element).hasText("hallo");
  });
});
