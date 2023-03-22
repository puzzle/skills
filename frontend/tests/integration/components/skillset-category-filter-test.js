import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import { setLocale, setupIntl } from "ember-intl/test-support";

module("Integration | Component | skillset-category-filter", function(hooks) {
  setupRenderingTest(hooks);
  setupIntl(hooks);

  test("it renders", async function(assert) {
    setLocale("de");

    this.set("parentCategories", {
      then(func) {
        return [
          { title: "Alle" },
          { title: "Software Engineering" },
          { title: "Beratung" },
          { title: "System Engineer" },
          { title: "Delivery" }
        ];
      }
    });
    await render(
      hbs`{{skillset-category-filter parentCategories=parentCategories}}`
    );

    assert.dom("#category-filter-label", document).includesText("Kategorie");
  });
});
