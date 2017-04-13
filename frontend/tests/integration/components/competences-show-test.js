import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('competence-show', 'Integration | Component | competence show', {
  integration: true
});

test('it renders competences from person', function(assert) {
  this.set('person', {name: 'Harry Potter',
    title: 'Zauberer',
    role: 'Schüler',
    birthdate: new Date('2000-01-01'),
    origin: 'Godrics hollow',
    location: 'Hogwarts',
    competences: 'very much',
    language: 'Parsel',
    martialStatus:  'ledig',
    status: 'Mitarbeiter'});

  this.render(hbs`{{competences-show person=person}}`);

  let text = this.$().text();

  assert.ok(text.includes('very much'));

  // doesn't show full person
  assert.ok(!text.includes('Harry Potter'));
  assert.ok(!text.includes('Zauberer'));
  assert.ok(!text.includes('Schüler'));
  assert.ok(!text.includes('01.01.2000'));
  assert.ok(!text.includes('Godrics hollow'));
  assert.ok(!text.includes('Hogwarts'));
  assert.ok(!text.includes('Parsel'));
  assert.ok(!text.includes('ledig'));
  assert.ok(!text.includes('Mitarbeiter'));
});
