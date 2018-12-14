import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import { setFlatpickrDate } from 'ember-flatpickr/test-support/helpers';
import page from 'frontend/tests/pages/people-new';
import editPage from 'frontend/tests/pages/person-edit';

moduleForAcceptance('Acceptance | create person');

skip('creating a new person', async function(assert) {
  assert.expect(10);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  await page.visit();

  assert.equal(currentURL(), '/people/new');

  /* eslint "no-undef": "off" */
  await selectChoose('#role', '.ember-power-select-option', 0);
  await selectChoose('#company', 'Firma');
  await selectChoose('#nationality', '.ember-power-select-option', 0);
  await selectChoose('#maritalStatus', 'verheiratet');

  setFlatpickrDate('.flatpickr-input', '26.10.2018')
  await page.createPerson({
    name: 'Hansjoggeli',
    title: 'Dr.',
    location: 'Chehrplatz Schwandi',
  });

  assert.ok(/^\/people\/\d+$/.test(currentURL()));
  assert.equal(editPage.profileData.name, 'Hansjoggeli');
  assert.equal(editPage.profileData.title, 'Dr.');
  assert.equal(editPage.profileData.role, 'Software-Engineer');
  assert.equal(editPage.profileData.birthdate, '26.10.2018');
  assert.equal(editPage.profileData.nationalities, 'Afghanistan');
  assert.equal(editPage.profileData.location, 'Chehrplatz Schwandi');
  assert.equal(editPage.profileData.maritalStatus, 'ledig');
  assert.ok(['DE', 'EN', 'FR'].includes(editPage.profileData.language[0]));
});

test('creating an empty new person', async function(assert) {
  assert.expect(2);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  await page.visit();

  assert.equal(currentURL(), '/people/new');

  await page.createPerson({});

  assert.equal(currentURL(), '/people/new');
  // TODO expect errors!
});
