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

    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    let text = $().text();
    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

    assert.dom().includesText("t:updated-at.message");
    assert.ok(text.includes("09.02.2008"));
  });
});
