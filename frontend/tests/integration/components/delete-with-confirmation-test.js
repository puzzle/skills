import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('button-with-confirmation', 'Integration | Component | button with confirmation', {
  integration: true
});

test('renders delete confirmation dialog with confirm message', function(assert) {
  this.set('company', {
    name: 'Firma1',
    web: 'www.example.org',
    email: 'info@example.org',
    phone: '123456789',
    partnermanager: 'Christoph Kolumbus',
    contactPerson: 'Urs Fischer',
    emailContactPerson: 'urs@fischer.ch',
    phoneContactPerson: '987654321',
    crm: 'crm123',
    level: 'X'
  });

  this.render(hbs`{{delete-with-confirmation message='Firma Firma1 wirklich löschen?' entry=company}}`);

  this.$('.deleteField').click()

  assert.ok(this.$().text().includes('Löschen bestätigen'));
  assert.ok(this.$().text().includes('Firma Firma1 wirklich löschen?'));
  assert.ok(this.$().text().includes('Abbrechen'));
  assert.ok(this.$().text().includes('Löschen'));
});
