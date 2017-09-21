
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('or', 'helper:or', {
  integration: true
});

test('it works', function(assert) {
  this.render(hbs`{{or 0 1}}`);

  assert.equal(this.$().text().trim(), '1');

  this.render(hbs`{{or 1 0}}`);

  assert.equal(this.$().text().trim(), '1');

  this.render(hbs`{{or 0 false 'hallo'}}`);

  assert.equal(this.$().text().trim(), 'hallo');
});

