import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('person-show', 'Integration | Component | person show', {
  integration: true
});

test('it renders person', function(assert) {
  this.set('company', {
    name: 'Bewerber'
  });

  this.set('person', {
    name: 'Harry Potter',
    email: 'harry@hogwarts.com',
    title: 'Zauberer',
    department: '/sys',
    company: this.get('company'),
    birthdate: new Date('2000-01-01'),
    nationality: 'FR',
    location: 'Hogwarts',
    maritalStatus: 'single'
  });

  this.set('role', {
    name: 'König'
  });

  this.set('person.peopleRoles', [{
    role: this.get('role'),
    level: 'S1',
    percent: 60,
  }]);

  this.set('person.languageSkills', [{
    language: 'DE',
    level: 'A1',
    certificate: ''
  }]);

  this.render(hbs`{{person-show person=person}}`);

  assert.ok(this.$().text().includes('Harry Potter'));
  assert.ok(this.$().text().includes('harry@hogwarts.com'));
  assert.ok(this.$().text().includes('Zauberer'));
  assert.ok(this.$().text().includes('König'));
  assert.ok(this.$().text().includes('S1'));
  assert.ok(this.$().text().includes('60%'));
  assert.ok(this.$().text().includes('/sys'));
  assert.ok(this.$().text().includes('Bewerber'));
  assert.ok(this.$().text().includes('01.01.2000'));
  assert.ok(this.$().text().includes('Frankreich'));
  assert.ok(this.$().text().includes('Hogwarts'));
  assert.ok(this.$().text().includes('ledig'));
  assert.ok(this.$().text().includes('DE'));
});
