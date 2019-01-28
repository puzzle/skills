import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | button-with-cofirmation', function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function() {
    this.intl = this.owner.lookup('service:intl');
    this.intl.setLocale('de');
  })

  test('renders delete confirmation dialog with confirm message', async function(assert) {

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
      level: 'X',
      toString: 'Firma1'
    });

    await render(hbs`{{delete-with-confirmation entry=company}}`);

    await click('.deleteField')

    assert.ok(this.$().text().includes('Löschen bestätigen'));
    assert.ok(this.$().text().includes('Firma1 wirklich löschen?'));
    assert.ok(this.$().text().includes('Abbrechen'));
    assert.ok(this.$().text().includes('Löschen'));
  });
});
