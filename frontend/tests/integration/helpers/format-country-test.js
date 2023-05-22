import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Helper | format-country", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders country name in German", async function(assert) {
    this.set("countryCode", "CH");

    await render(hbs`{{get (format-country countryCode) 1}}`);

    assert.true(this.element.textContent.includes("Schweiz"));
  });
});
