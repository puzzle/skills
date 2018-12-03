import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('person-show', 'Integration | Component | person show', {
  integration: true
});

test('it renders person', function(assert) {
  this.set('person', {
    name: 'Harry Potter',
    title: 'Zauberer',
    birthdate: new Date('2000-01-01'),
    nationality: 'FR',
    location: 'Hogwarts',
    language: 'Parsel',
    martialStatus: 'ledig'
  });

  this.set('person.roles', [{
    name: 'System-Engineer',
  }]);

  this.render(hbs`{{person-show person=person}}`);

  assert.ok(this.$().text().includes('Harry Potter'));
  assert.ok(this.$().text().includes('Zauberer'));
  assert.ok(this.$().text().includes('System-Engineer'));
  assert.ok(this.$().text().includes('01.01.2000'));
  assert.ok(this.$().text().includes('Frankreich'));
  assert.ok(this.$().text().includes('Hogwarts'));
  assert.ok(this.$().text().includes('Parsel'));
  assert.ok(this.$().text().includes('ledig'));
});
