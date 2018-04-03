import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('company-uebersicht-edit', 'Integration | Component | company uebersicht edit', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{company-uebersicht-edit}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#company-uebersicht-edit}}
      template block text
    {{/company-uebersicht-edit}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
