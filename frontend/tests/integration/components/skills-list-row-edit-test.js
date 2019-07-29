import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | skills-list-row-edit", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders an edit row with data", async function(assert) {
    this.set("skill", {
      title: "Ruby",
      portfolio: "aktiv",
      radar: "assess",
      category: {
        title: "Software-Engineering"
      },
      people: ["person1", "person2"]
    });

    this.set("childCategories", {
      then(func) {
        return { title: "Delivery" };
      }
    });

    await render(
      hbs`{{skills-list-row-edit skill=skill childCategories=childCategories}}`
    );

    assert.ok(this.element.textContent.trim().includes("2"));
    assert.ok(this.element.textContent.trim().includes("Software-Engineering"));
    assert.ok(this.element.textContent.trim().includes("assess"));
    assert.ok(this.element.textContent.trim().includes("aktiv"));
  });
});
