import { moduleForComponent, skip } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('competence-show', 'Integration | Component | competence show', {
  integration: true
});

skip('it renders competences from person', function(assert) {
  this.set('person', {
    name: 'Harry Potter',
    title: 'Zauberer',
    role: 'Schüler',
    birthdate: new Date('2000-01-01'),
    origin: 'Godrics hollow',
    location: 'Hogwarts',
    language: 'Parsel',
    martialStatus:  'ledig',
    personCompetences: [
      { category: "frontend", offer: ['test1', 'holz'] },
      { category: "backend" }
    ]
  });

  this.render(hbs`{{competences-show person=person}}`);

  let text = this.$().text();

  assert.ok(text.includes('frontend'));
  assert.ok(text.includes('backend'));
  assert.ok(text.includes('test1'));
  assert.ok(text.includes('holz'));

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
