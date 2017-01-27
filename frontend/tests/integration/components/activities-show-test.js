import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('activity-show', 'Integration | Component | activity show', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('activity', {});

  this.render(hbs`{{activity-show}}`);

  assert.ok(this.$().text().includes('Harry Potter'));
});
