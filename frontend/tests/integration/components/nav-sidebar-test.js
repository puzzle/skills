import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | nav-sidebar", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders nav-sidebar without additional content", async function(assert) {
    this.set("sidebarItems", {
      Personalien: "#particulars",
      Kernkompetenzen: "#corecompetences",
      Ausbildung: "#educations"
    });

    await render(hbs`{{nav-sidebar items=sidebarItems}}`);

    let listEntries = this.$("li");

    assert.equal(listEntries[0].innerText, "Personalien");
    assert.equal(listEntries[1].innerText, "Kernkompetenzen");
    assert.equal(listEntries[2].innerText, "Ausbildung");
  });

  test("it renders nav-sidebar with additional content", async function(assert) {
    this.set("sidebarItems", {
      Personalien: "#particulars",
      Kernkompetenzen: "#corecompetences",
      Ausbildung: "#educations"
    });

    await render(hbs`
      {{#nav-sidebar items=sidebarItems}}
        <ul>
          <li>Weiterausbildung</li>
          <li>Projekte</li>
        </ul>
      {{/nav-sidebar}}
    `);

    let listEntries = this.$("li");

    assert.equal(listEntries[0].innerText, "Personalien");
    assert.equal(listEntries[1].innerText, "Kernkompetenzen");
    assert.equal(listEntries[2].innerText, "Ausbildung");
    assert.equal(listEntries[3].innerText, "Weiterausbildung");
    assert.equal(listEntries[4].innerText, "Projekte");
  });
});
