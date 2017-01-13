import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('advanced-training-new', 'Integration | Component | advanced training new', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{advanced-training-new}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#advanced-training-new}}
      template block text
    {{/advanced-training-new}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
