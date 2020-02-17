import { module, test } from "qunit";
import { setupTest } from "ember-qunit";

module("person", "Unit | Serializer | person", function(hooks) {
  setupTest(hooks);

  test("it does not serialize unpermitted attrs", function(assert) {
    let record = this.owner.lookup("service:store").createRecord("person");

    let {
      data: { attributes: attrs }
    } = record.serialize();

    assert.notOk("picture_path" in attrs);
    assert.notOk("updated_at" in attrs);
    assert.notOk("origin_person_id" in attrs);
    assert.ok("name" in attrs);
  });
});
