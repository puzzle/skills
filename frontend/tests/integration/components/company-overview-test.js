import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('company-overview', 'Integration | Component | company overview', {
  integration: true
});

test('it renders company-overview', function(assert) {
  this.set('company', {
    name: 'Firma',
    web: 'www.example.org',
    email: 'info@example.org',
    phone: '123456789',
    partnermanager: 'Christoph Kolumbus',
    contactPerson: 'Urs Fischer',
    emailContactPerson: 'urs@fischer.ch',
    phoneContactPerson: '987654321',
    crm: 'crm123',
    level: 'X',
  });

  this.render(hbs`{{company-overview company=company}}`);

  assert.ok(this.$().text().includes('Firma'));
  assert.ok(this.$().text().includes('www.example.org'));
  assert.ok(this.$().text().includes('123456789'));
  assert.ok(this.$().text().includes('Christoph Kolumbus'));
  assert.ok(this.$().text().includes('Urs Fischer'));
  assert.ok(this.$().text().includes('urs@fischer.ch'));
  assert.ok(this.$().text().includes('987654321'));
  assert.ok(this.$().text().includes('crm123'));
  assert.ok(this.$().text().includes('X'));
});
