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

  assert.ok(this.$().text().indexOf('very much') !== -1);

  // doesn't show full person
  assert.ok(this.$().text().indexOf('Harry Potter') === -1);
  assert.ok(this.$().text().indexOf('Zauberer') === -1);
  assert.ok(this.$().text().indexOf('Schüler') === -1);
  assert.ok(this.$().text().indexOf('01.01.2000' === -1));
  assert.ok(this.$().text().indexOf('Godrics hollow' === -1));
  assert.ok(this.$().text().indexOf('Hogwarts' === -1));
  assert.ok(this.$().text().indexOf('Parsel' === -1));
  assert.ok(this.$().text().indexOf('ledig' === -1));
  assert.ok(this.$().text().indexOf('Mitarbeiter' === -1));
});
