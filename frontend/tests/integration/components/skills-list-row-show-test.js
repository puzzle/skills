import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | skills-list-row-show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders", async function(assert) {
    this.set("skill", {
      title: "Ruby",
      portfolio: "aktiv",
      radar: "assess",
      category: {
        title: "Software-Engineering"
      },
      people: ["person1", "person2"]
    });

    await render(hbs`{{skills-list-row-show skill=skill}}`);

    assert.ok(this.element.textContent.trim().includes("2"));
    assert.ok(this.element.textContent.trim().includes("Software-Engineering"));
    assert.ok(this.element.textContent.trim().includes("assess"));
    assert.ok(this.element.textContent.trim().includes("aktiv"));
  });
});
