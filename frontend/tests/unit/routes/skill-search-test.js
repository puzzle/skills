import { module, test } from "qunit";
import { setupTest } from "ember-qunit";

module("Unit | Route | skill_search", function(hooks) {
  setupTest(hooks);

  test("it exists", function(assert) {
    let route = this.owner.lookup("route:skill-search");
    assert.ok(route);
  });
});
