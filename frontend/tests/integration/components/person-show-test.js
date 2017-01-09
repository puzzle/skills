import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('person-show', 'Integration | Component | person show', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('person', {name: 'Harry Potter',
                      title: 'Zauberer',
                      role: 'Schüler',
                      birthdate: '01.01.2000',
                      origin: 'Godrics hollow',
                      "location": 'Hogwarts',
                      language: 'Parsel',
                      martialStatus:  'ledig',
                      "status": 'Mitarbeiter'});

  this.render(hbs`{{person-show person=person}}`);

  assert.ok(this.$().text().includes('Harry Potter'));
  assert.ok(this.$().text().includes('Zauberer'));
  assert.ok(this.$().text().includes('Schüler'));
  assert.ok(this.$().text().includes('01.01.2000'));
  assert.ok(this.$().text().includes('Godrics hollow'));
  assert.ok(this.$().text().includes('Hogwarts'));
  assert.ok(this.$().text().includes('Parsel'));
  assert.ok(this.$().text().includes('ledig'));
  assert.ok(this.$().text().includes('Mitarbeiter'));
});
