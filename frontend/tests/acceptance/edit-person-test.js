import { test, skip } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import applicationPage from 'frontend/tests/pages/application';
import page from 'frontend/tests/pages/person-edit';
import { triggerKeyUp } from 'ember-keyboard';
import { openDatepicker } from 'ember-pikaday/helpers/pikaday';
import $ from 'jquery';

moduleForAcceptance('Acceptance | edit person', {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: 'development_user',
      token: '1234'
    });
  }
});

test('/people/:id edit person data', async function(assert) {
  assert.expect(11);

  // Go to the start page and select a user from the dropdown
  await applicationPage.visitHome('/');
  await selectChoose('#people-search', '.ember-power-select-option', 0);

  // Go into person-edit
  await page.toggleEditForm();

  // Selection for all the power selects
  /* eslint "no-undef": "off" */
  await selectChoose('#role', '.ember-power-select-option', 0)
  await selectChoose('#company', 'Firma');
  await selectChoose('#nationality', "Samoa");
  await selectChoose('#maritalStatus', 'verheiratet');

  // interactor is the interactable object for the pikaday-datepicker
  let interactor = openDatepicker($('.birthdate_pikaday > input'));

  // Cant be more/less than +/- 10 Years from today
  interactor.selectDate(new Date(2019,1,19))

  // Testing if pikaday got the right dates
  assert.equal(interactor.selectedDay(), 19)
  assert.equal(interactor.selectedMonth(), 1)
  assert.equal(interactor.selectedYear(), 2019)

  // Fill out the persons text fields
  await page.editForm.name('Hansjoggeli');
  await page.editForm.title('Dr.');
  await page.editForm.location('Chehrplatz Schwandi');

  // Submit the edited content
  await page.editForm.submit();

  // Assert that all we changed is present
  assert.equal(page.profileData.name, 'Hansjoggeli');
  assert.equal(page.profileData.title, 'Dr.');
  assert.equal(page.profileData.role, 'System-Engineer');
  assert.equal(page.profileData.nationalities, 'Samoa');
  assert.equal(page.profileData.location, 'Chehrplatz Schwandi');
  assert.equal(page.profileData.birthdate, '19.02.2019')

  // Toggle Edit again
  await page.toggleEditForm();

  // Enable two Nationalities
  await page.toggleNationalities();

  // Select the second nationality
  await selectChoose('#nationality2', "Schweiz");

  // Submit it
  await page.editForm.submit();

  // Assert that it is there
  assert.equal(page.profileData.nationalities, 'Samoa , Schweiz')

  // go into edit again
  await page.toggleEditForm();

  // Toggle the second nationality option off
  await page.toggleNationalities();

  // Submit it
  await page.editForm.submit();

  // Check that the second nationality is gone
  assert.equal(page.profileData.nationalities, 'Samoa')
});

test('/people/:id abort with escape', async function(assert) {
  assert.expect(1);
  await applicationPage.visitHome('/');
  await selectChoose('#people-search', '.ember-power-select-option', 0);

  await page.toggleEditForm();

  await triggerKeyUp('Escape');

  // Testing if the header of competence-show is there, stherefore profing we're in show
  assert.equal($('#competence-show-header').attr('class'), "card-header bg-info");
});

skip('/people/:id edit person competences', async function(assert) {
  assert.expect(4);

  await applicationPage.visitHome('/');
  await selectChoose('#people-search', '.ember-power-select-option', 0);

  await page.competences.toggleForm();
  await page.competences.textarea(
    '\n' +
    'Competence 1\n' +
    '\n' +
    'Competence 2\n' +
    'Competence 3\n' +
    '\n' +
    '\n'
  );
  await page.competences.submit();

  assert.equal(page.competences.list().count, 3);
  assert.equal(page.competences.list(0).text, 'Competence 1');
  assert.equal(page.competences.list(1).text, 'Competence 2');
  assert.equal(page.competences.list(2).text, 'Competence 3');
});
