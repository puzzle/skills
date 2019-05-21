import { moduleForModel, test } from "ember-qunit";

moduleForModel("company", "Unit | Serializer | company", {
  needs: [
    "model:location",
    "model:employee-quantity",
    "model:person",
    "model:offer",
    "serializer:company"
  ]
});

test("it does not serialize unpermitted attrs", function(assert) {
  let record = this.subject();

  let {
    data: { attributes: attrs }
  } = record.serialize();

  assert.notOk("created_at" in attrs);
  assert.notOk("updated_at" in attrs);
  assert.notOk("my_company" in attrs);
  assert.ok("name" in attrs);
});
