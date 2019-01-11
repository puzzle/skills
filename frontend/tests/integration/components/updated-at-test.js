import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('updated-at', 'Integration | Component | updated at', {
  integration: true
});

test('it renders', function(assert) {
  this.set('person', {
    name: 'Harry Potter',
    title: 'Zauberer',
    birthdate: new Date('2000-01-01'),
    nationality: 'FR',
    location: 'Hogwarts',
    maritalStatus: 'single',
    updatedAt: new Date('2008-02-09')
  });

  this.render(hbs`{{updated-at entry=person}}`);

  assert.ok(this.$().text().includes('Zuletzt bearbeitet:'));
  assert.ok(this.$().text().includes('09.02.2008'));
});
