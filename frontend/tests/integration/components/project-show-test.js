import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('project-show', 'Integration | Component | project show', {
  integration: true
});

test('it renders project', function(assert) {
  this.set('project', {
    title: 'Dreaming Project',
    description: 'Schlafen',
    role: 'Träumer',
    technology: 'Bed',
    year_from: '1990',
    year_to: '1991'
  });

  this.render(hbs`{{project-show 
    project=project
    selectProject=(action (mut projectEditing))
  }}`);

  assert.ok(this.$().text().indexOf('Dreaming Project') !== -1);
  assert.ok(this.$().text().indexOf('Schlafen') !== -1);
  assert.ok(this.$().text().indexOf('Träumer') !== -1);
  assert.ok(this.$().text().indexOf('Bed') !== -1);
  assert.ok(this.$().text().indexOf('1990') !== -1);
  assert.ok(this.$().text().indexOf('1991') !== -1);
});
