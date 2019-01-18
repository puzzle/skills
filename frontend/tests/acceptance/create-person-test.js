import { test, skip } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import page from 'frontend/tests/pages/people-new';
import editPage from 'frontend/tests/pages/person-edit';
import { openDatepicker } from 'ember-pikaday/helpers/pikaday';

moduleForAcceptance('Acceptance | create person');

test('creating a new person', async function(assert) {
  assert.expect(13);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  // Visits person/new
  await page.newPersonPage.visit();
  assert.equal(currentURL(), '/people/new');

  // Selection for all the power selects
  await selectChoose('#role', '.ember-power-select-option', 0);
  await selectChoose('#company', 'Firma');
  await selectChoose('#nationality', '.ember-power-select-option', 0);
  await selectChoose('#maritalStatus', 'verheiratet');

  // interactor is the interactable object for the pikaday-datepicker
  let interactor = openDatepicker(Ember.$('.birthdate_pikaday > input'));

  // Cant be more/less than +/- 10 Years from today
  interactor.selectDate(new Date(2019,1,19))

  // Testing if pikaday got the right dates
  assert.equal(interactor.selectedDay(), 19)
  assert.equal(interactor.selectedMonth(), 1)
  assert.equal(interactor.selectedYear(), 2019)

  // Filling out the text fields
  await page.newPersonPage.name('Dolores')
  await page.newPersonPage.title('Dr.');
  await page.newPersonPage.location('Westworld');

  // Actually creating the person with the above entered
  await page.newPersonPage.createPerson({});

  // Current Url now should be "people/d+" where d+ = any amount of numbers (like an id)
  assert.ok(/^\/people\/\d+$/.test(currentURL()));

  // Assert that all we entered above actually made it into the profile correctly
  assert.equal(editPage.profileData.name, 'Dolores');
  assert.equal(editPage.profileData.title, 'Dr.');
  assert.equal(editPage.profileData.role, 'Software-Engineer');
  assert.equal(editPage.profileData.birthdate, '19.02.2019');
  assert.equal(editPage.profileData.nationalities, 'Afghanistan');
  assert.equal(editPage.profileData.location, 'Westworld');
  assert.equal(editPage.profileData.maritalStatus, 'verheiratet');
  assert.ok(['DE', 'EN', 'FR'].includes(editPage.profileData.language[0]));
});

test('creating an empty new person', async function(assert) {
  assert.expect(2);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  await page.newPersonPage.visit();

  assert.equal(currentURL(), '/people/new');

  await page.newPersonPage.createPerson({});

  assert.equal(currentURL(), '/people/new');
  // TODO expect errors!
});
