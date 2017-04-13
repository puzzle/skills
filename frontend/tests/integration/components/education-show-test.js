import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('education-show', 'Integration | Component | education show', {
  integration: true
});

test('it renders education', function(assert) {
  this.set('education', {
    title: 'Ausbildung',
    location: 'Bern',
    year_from: '1990',
    year_to: '1995'
  });

  this.render(hbs`{{education-show 
    selectEducation=(action (mut educationEditing)) 
    education=education}}`);

  assert.ok(this.$().text().indexOf('Ausbildung') !== -1);
  assert.ok(this.$().text().indexOf('Bern') !== -1);
  assert.ok(this.$().text().indexOf('1990') !== -1);
  assert.ok(this.$().text().indexOf('1995') !== -1);
});
