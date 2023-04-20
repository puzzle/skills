import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import { setupIntl } from "ember-intl/test-support";

module("Integration | Component | skillset-defaultset-filter", function(hooks) {
  setupRenderingTest(hooks);
  setupIntl(hooks);

  test("it renders", async function(assert) {
    await render(hbs`{{skillset-defaultset-filter}}`);

    assert
      .dom("#defaultFilterAll", document)
      .includesText("t:skillset-defaultset-filter.all:()");
    assert
      .dom("#defaultFilterNew", document)
      .includesText("t:skillset-defaultset-filter.new:()");
    assert.dom("#defaultFilterDefault", document).includesText("Default");
  });
});
