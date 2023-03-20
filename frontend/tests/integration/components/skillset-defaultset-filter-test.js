import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import { setLocale, setupIntl } from "ember-intl/test-support";

module("Integration | Component | skillset-defaultset-filter", function(hooks) {
  setupRenderingTest(hooks);
  setupIntl(hooks);

  setLocale("de");

  test("it renders", async function(assert) {
    await render(hbs`{{skillset-defaultset-filter}}`);

    assert.dom("#defaultFilterAll", document).includesText("Alle");
    assert.dom("#defaultFilterNew", document).includesText("Neue");
    assert.dom("#defaultFilterDefault", document).includesText("Default");
  });
});
