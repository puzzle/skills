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

  assert.ok(this.$().text().indexOf('das ist ein kommentar') !== -1);
  assert.ok(this.$().text().indexOf('frontend') !== -1);
  assert.ok(this.$().text().indexOf('ember') !== -1);
  assert.ok(this.$().text().indexOf('angular' !== -1));
  assert.ok(this.$().text().indexOf('backend' !== -1));
  assert.ok(this.$().text().indexOf('java' !== -1));
  assert.ok(this.$().text().indexOf('ruby' !== -1));
});
