import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('delete-confirmation', 'Integration | Component | delete confirmation', {
  integration: true
});

test('it renders', function(assert) {
  this.set('company', {
    offerComment: 'das ist ein kommentar',
    offers: [
      { category: 'frontend', offer: ['ember', 'angular'] },
      { category: 'backend', offer: ['java', 'ruby'] }
    ]
  });

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{delete-confirmation object=company index='1'}}`);

  assert.ok(this.$().text().indexOf('Willst du das wirklich löschen?') !== -1);
});
