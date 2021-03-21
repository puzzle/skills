import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Helper | toLowercase", function(hooks) {
  setupRenderingTest(hooks);

  // Replace this with your real tests.
  test("it renders", async function(assert) {
    this.set("inputValue", "1234");

    await render(hbs`{{to-lowercase inputValue}}`);

    assert.dom(this.element).hasText("1234");
  });
});
