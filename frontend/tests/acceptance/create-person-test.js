import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import page from 'frontend/tests/pages/people-new';
import { openDatepicker } from 'ember-pikaday/helpers/pikaday';
import $ from 'jquery';

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
  /* eslint "no-undef": "off" */
  await selectChoose('#role', '.ember-power-select-option', 0);
  await selectChoose('#company', '.ember-power-select-option', 0);
  await selectChoose('#nationality', '.ember-power-select-option', 0);
  await selectChoose('#maritalStatus', '.ember-power-select-option', 0);

  // interactor is the interactable object for the pikaday-datepicker
  let interactor = await openDatepicker($('.birthdate_pikaday > input'));

  // Cant be more/less than +/- 10 Years from today
  await interactor.selectDate(new Date(2019,1,19))

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

  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  for (let i = 0; i < 3; i++) {
    if (/^\/people\/\d+$/.test(currentURL())) break;
    await sleep(500)
  }

  // Current Url now should be "people/d+" where d+ = any amount of numbers (like an id)
  assert.ok(/^\/people\/\d+$/.test(currentURL(), 'url, current url: ' + currentURL()));

  // Assert that all we entered above actually made it into the profile correctly
  assert.equal(page.profileData.name, 'Dolores', 'name, current url: ' + currentURL());
  assert.equal(page.profileData.title, 'Dr.');
  assert.equal(page.profileData.role, 'Software-Engineer');
  assert.equal(page.profileData.birthdate, '19.02.2019');
  assert.equal(page.profileData.nationalities, 'Afghanistan');
  assert.equal(page.profileData.location, 'Westworld');
  assert.equal(page.profileData.maritalStatus, 'ledig');
  assert.ok(['DE', 'EN', 'FR'].includes(page.profileData.language[0]));
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
