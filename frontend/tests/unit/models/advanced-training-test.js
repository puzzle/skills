import { moduleForModel, test } from 'ember-qunit';

moduleForModel('advanced-training', 'Unit | Model | advanced training', {
  // Specify the other units that are required for this test.
  needs: ['model:person', 'service:intl']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
