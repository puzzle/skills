import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import { setupIntl } from "ember-intl/test-support";

module("Integration | Component | updated-at", function(hooks) {
  setupRenderingTest(hooks);
  setupIntl(hooks);

  test("it renders", async function(assert) {
    this.set("person", {
      name: "Harry Potter",
      title: "Zauberer",
      birthdate: new Date("2000-01-01"),
      nationality: "FR",
      location: "Hogwarts",
      maritalStatus: "single",
      updatedAt: new Date("2008-02-09")
    });
    await render(hbs`{{updated-at entry=person}}`);

    assert.dom(".updated-at", document).includesText("t:updated-at.message:()");
    assert.dom(".updated-at", document).includesText("09.02.2008");
  });
});
