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

  assert.ok(this.$().text().indexOf('Firma') !== -1);
  assert.ok(this.$().text().indexOf('www.example.org') !== -1);
  assert.ok(this.$().text().indexOf('123456789') !== -1);
  assert.ok(this.$().text().indexOf('Christoph Kolumbus' !== -1));
  assert.ok(this.$().text().indexOf('Urs Fischer' !== -1));
  assert.ok(this.$().text().indexOf('urs@fischer.ch' !== -1));
  assert.ok(this.$().text().indexOf('987654321' !== -1));
  assert.ok(this.$().text().indexOf('crm123' !== -1));
  assert.ok(this.$().text().indexOf('X' !== -1));
});
