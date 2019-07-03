import { module, test } from "qunit";
import { setupTest } from "ember-qunit";

module("Unit | Service | selected-person", function(hooks) {
  setupTest(hooks);

  // Replace this with your real tests.
  test("it clears all attributes", function(assert) {
    assert.expect(3);

    let service = this.owner.lookup("service:selected-person");

    service.set("personId", 1);
    service.set("selectedSubRoute", "people.index");
    service.set("queryParams", { rated: true });

    service.clear();

    assert.equal(service.get("personId"), null);
    assert.equal(service.get("selectedSubRoute"), null);
    assert.equal(service.get("queryParams"), null);
  });

  test("it isPresent once personId and selectedSubRoute exist", function(assert) {
    assert.expect(4);

    let service = this.owner.lookup("service:selected-person");

    assert.equal(service.get("isPresent"), false);

    service.set("personId", 1);
    service.set("selectedSubRoute", "people.index");

    assert.equal(service.get("isPresent"), true);

    service.set("selectedSubRoute", null);

    assert.equal(service.get("isPresent"), false);

    service.set("queryParams", { rated: true });

    assert.equal(service.get("isPresent"), false);
  });
});
