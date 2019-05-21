import { moduleForModel, test } from "ember-qunit";

moduleForModel("language-skill", "Unit | Model | language skill", {
  needs: ["model:person"]
});
test("it exists", function(assert) {
  let model = this.subject();
  assert.ok(!!model);
});
