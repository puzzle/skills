import { eq } from "frontend/helpers/eq";
import { module, test } from "qunit";

module("Unit | Helper | eq", function() {
  // Replace this with your real tests.
  test("it works", function(assert) {
    assert.ok(eq([42, 42]));
    assert.notOk(eq([42, "42"]));
    assert.notOk(eq([42, 41]));
  });
});
