import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | people-skill-edit", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders people-skill-edit with data", async function(assert) {
    this.set("peopleSkill", {
      skill: {
        title: "Rails"
      },
      level: 2,
      interest: 3,
      certificate: false,
      coreCompetence: true
    });

    await render(hbs`{{people-skill-edit peopleSkill=peopleSkill}}`);

    let text = this.$().text();
    let checkboxes = this.$('[type="checkbox"]');

    assert.ok(text.includes("Rails"));
    assert.ok(text.includes("Junior"));
    assert.notOk(checkboxes[0].checked);
    assert.ok(checkboxes[1].checked);
  });
});
