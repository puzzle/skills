import { moduleForModel, test } from "ember-qunit";

moduleForModel("skill", "Unit | Model | skill", {
  // Specify the other units that are required for this test.
  needs: ["model:person", "model:category", "model:people-skill"]
});

test("it exists", function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
