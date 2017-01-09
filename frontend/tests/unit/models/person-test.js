import { moduleForModel, test } from 'ember-qunit';

moduleForModel('person', 'Unit | Model | person', {
  // Specify the other units that are required for this test.
  needs: ['model:education', 'model:activity', 'model:advancedTraining', 'model:project', 'model:competence']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
