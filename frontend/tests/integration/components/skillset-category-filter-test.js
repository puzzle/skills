import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import Service from "@ember/service";

const storeStub = Service.extend({
  query(type, options) {
    return Promise.all([
      "Software Engineering",
      "Beratung",
      "System Engineer",
      "Delivery"
    ]);
  }
});

module("Integration | Component | skillset-category-filter", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders", async function(assert) {
    this.owner.register("service:store", storeStub);
    await render(hbs`{{skillset-category-filter}}`);

    let text = this.$().text();

    assert.ok(text.includes("Kategorie"));
  });
});
