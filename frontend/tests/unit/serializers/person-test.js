import { moduleForModel, test } from 'ember-qunit';

moduleForModel('person', 'Unit | Serializer | person', {
  needs: [
    'model:education',
    'model:person-competence',
    'model:advanced-training',
    'model:activity',
    'model:project',
    'model:expertise-topic-skill-value',
    'model:company',
    'serializer:person',
  ]
});

test('it does not serialize unpermitted attrs', function(assert) {
  let record = this.subject();

  let { data: { attributes: attrs } } = record.serialize();

  assert.notOk('picture_path' in attrs);
  assert.notOk('updated_at' in attrs);
  assert.notOk('origin_person_id' in attrs);
  assert.ok('name' in attrs);
});
