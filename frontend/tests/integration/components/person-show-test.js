import { moduleForComponent, skip } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('person-show', 'Integration | Component | person show', {
  integration: true
});

skip('it renders person', function(assert) {
  this.set('person', {
    name: 'Harry Potter',
    title: 'Zauberer',
    role: 'Schüler',
    birthdate: new Date('2000-01-01'),
    origin: 'Godrics hollow',
    location: 'Hogwarts',
    language: 'Parsel',
    martialStatus:  'ledig',
    status: 'Mitarbeiter'
  });

  this.render(hbs`{{person-show person=person}}`);

  assert.ok(this.$().text().indexOf('Harry Potter') !== -1);
  assert.ok(this.$().text().indexOf('Zauberer') !== -1);
  assert.ok(this.$().text().indexOf('Schüler') !== -1);
  assert.ok(this.$().text().indexOf('01.01.2000' !== -1));
  assert.ok(this.$().text().indexOf('Godrics hollow' !== -1));
  assert.ok(this.$().text().indexOf('Hogwarts' !== -1));
  assert.ok(this.$().text().indexOf('Parsel' !== -1));
  assert.ok(this.$().text().indexOf('ledig' !== -1));
  assert.ok(this.$().text().indexOf('Mitarbeiter' !== -1));
});
