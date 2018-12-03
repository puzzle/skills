import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('company-offer', 'Integration | Component | company offer', {
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

  this.render(hbs`{{company-offer company=company}}`);

  assert.ok(this.$().text().includes('das ist ein kommentar'));
  assert.ok(this.$().text().includes('frontend'));
  assert.ok(this.$().text().includes('ember'));
  assert.ok(this.$().text().includes('angular'));
  assert.ok(this.$().text().includes('backend'));
  assert.ok(this.$().text().includes('java'));
  assert.ok(this.$().text().includes('ruby'));
});
