import hbs from "htmlbars-inline-precompile";
import { moduleForComponent, test } from "ember-qunit";

moduleForComponent(
  "person-sidebar",
  "Integration | Component | person sidebar",
  {
    integration: true
  }
);

test("it renders sidebar", function(assert) {
  this.render(hbs`{{person-sidebar}}`);

  assert.ok(
    this.$()
      .text()
      .includes("Personalien")
  );
  assert.ok(
    this.$()
      .text()
      .includes("Kernkompetenzen")
  );
  assert.ok(
    this.$()
      .text()
      .includes("Ausbildung")
  );
  assert.ok(
    this.$()
      .text()
      .includes("Weiterbildung")
  );
  assert.ok(
    this.$()
      .text()
      .includes("Stationen")
  );
  assert.ok(
    this.$()
      .text()
      .includes("Projekte")
  );
});
