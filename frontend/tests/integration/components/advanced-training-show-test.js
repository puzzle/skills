import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('advanced-training-show', 'Integration | Component | advanced training show', {
  integration: true
});

test('it renders advanced-training', function(assert) {
  this.set('advanced-training', {
    description: 'Lucid Dreaming',
    year_from: '1988',
    year_to: '1989'
  });

  this.render(hbs`{{advanced-training-show 
    advanced-training=advanced-training
    selectAdvancedTraining=(action (mut advancedTrainingEditing))
  }}`);

  assert.ok(this.$().text().indexOf('Lucid Dreaming') !== -1);
  assert.ok(this.$().text().indexOf('1988') !== -1);
  assert.ok(this.$().text().indexOf('1989') !== -1);
});
