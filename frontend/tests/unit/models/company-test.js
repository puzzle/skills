import { moduleForModel } from 'ember-qunit';

moduleForModel('company', 'Unit | Model | company', {
  // Specify the other units that are required for this test.
  needs: ['model:location', 'model:employee quantity', 'model:people']
});
