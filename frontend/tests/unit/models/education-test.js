import { moduleForModel, test } from 'ember-qunit';

moduleForModel('education', 'Unit | Model | education', {
  // Specify the other units that are required for this test.
  needs: ['model:person']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
