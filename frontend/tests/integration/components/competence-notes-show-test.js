import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | competenceNotes show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders competences from person", async function(assert) {
    this.set("person", {
      competenceNotes: "Ruby\nJava\nJavascript"
    });

    await render(hbs`{{competence-notes-show person=person}}`);

    let text = this.element.textContent;

    // doesn't show full person
    assert.ok(text.includes("Ruby"));
    assert.ok(text.includes("Java"));
    assert.ok(text.includes("Javascript"));
  });
});
