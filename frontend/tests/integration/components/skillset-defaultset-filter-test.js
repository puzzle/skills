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

    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    let text = $().text();
    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

    assert.dom().includesText("t:skillset-defaultset-filter.all");
    assert.dom().includesText("t:skillset-defaultset-filter.new");
    assert.ok(text.includes("Default"));
  });
});
