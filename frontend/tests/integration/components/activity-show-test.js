import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('activity-show', 'Integration | Component | activity show', {
  integration: true
});

test('it renders activity', function(assert) {
  this.set('activity', {
    description: 'Schlafen',
    role: 'Träumer',
    year_from: '1990',
    year_to: '1991'
  });

  this.render(hbs`{{activity-show 
    activity=activity
    selectActivity=(action (mut activityEditing))
  }}`);

  assert.ok(this.$().text().indexOf('Schlafen') !== -1);
  assert.ok(this.$().text().indexOf('Träumer') !== -1);
  assert.ok(this.$().text().indexOf('1990') !== -1);
  assert.ok(this.$().text().indexOf('1991') !== -1);
});
