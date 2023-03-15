import hbs from "htmlbars-inline-precompile";
import { module, test } from "qunit";

module(
  "competence-notes-show",
  "Integration | Component | competence-notes-show",
  function() {
    test("it renders competences from person", function(assert) {
      this.set("person", {
        competenceNotes: "Ruby\nJava\nJavascript"
      });

      this.render(hbs`{{competence-notes-show person=person}}`);

      let text = this.$().text();

      // doesn't show full person
      assert.ok(text.includes("Ruby"));
      assert.ok(text.includes("Java"));
      assert.ok(text.includes("Javascript"));
    });
  }
);
